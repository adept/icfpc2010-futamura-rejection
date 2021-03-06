import re
import mechanize
import sys
import time
import csv
from pprint import pprint, pformat
from submit_car import PASSWD, USER
from mechanize._beautifulsoup import BeautifulSoup, BeautifulStoneSoup

# if true, makes assertions on fuel errors
FAIL_ON_ASSERT = False

def login():
    br = mechanize.Browser()
    br.open("http://icfpcontest.org/icfp10/login")
    assert br.viewing_html()
    
    br.select_form(name="f")    
    br["j_username"] = USER
    br["j_password"] = PASSWD
    br.submit()
    return br

def raw_submit_fuel(car, fuel, br=None):
    if br is None:
        br = login()
    
    res = br.open("http://icfpcontest.org/icfp10/instance/{0}/solve/form".format(car))
    
    br.select_form(nr=0)
        
    br["contents"] = fuel

    response = br.submit()
    
    body = response.read()
#    print body
    
    re_spanerr = re.compile(r"class=\"errors\"\>(.*?)\<\/span\>", re.S + re.M)
    re_pre = re.compile(r"\<pre\>(.*?)\</pre\>", re.S + re.M)

    mpre = re_pre.search(body)
    mspan = re_spanerr.search(body)
    if mspan:
        error = mspan.group(1)
        return error
    elif mpre:
        return mpre.group(1)
    else:
        return "OK " + body


def submit_test_car_fuel(cardata, fuel):

    br = mechanize.Browser()
    
    #br.set_response()
    res = br.open("http://nfa.imn.htwk-leipzig.de/icfpcont/")
    #res = br.post("http://nfa.imn.htwk-leipzig.de/icfpcont/")
    
    br.select_form(nr=0)
        
    br["G0"] = cardata
    br["G1"] = fuel

    response = br.submit()
    
    body = response.read()
#    print body
    bs = BeautifulSoup(body)
    
    result = ''
    for pre in bs.fetch('pre'):
        result += pre.renderContents()
    
    return result



CACHE_FILE = './submitted_solutions.txt'

def load_cache():
    global cache
    with open(CACHE_FILE) as cache_file:
        cache = eval(cache_file.read())
        
def save_cache():
    global cache
    #with open(CACHE_FILE, 'wt') as cache_file: 
    #    print >> cache_file, "# car: scheme"
    #    dump = pformat(cache).replace("{", "{\n").replace("}", "\n}")
    #    print >> cache_file, dump


def submit_fuel(car, fuel, br=None):
    car = int(car)
    
    assert car != 219
    
    load_cache()
    if car in cache and len(fuel) >= len(cache[car]):
        if fuel == cache[car]:
            print 'this solution was already submitted'
        elif len(fuel) == len(cache[car]):
            print 'equivalent solution was already submitted'
        else:
            assert len(fuel) > len(cache[car])
            print 'shorter solution was already submitted'
        return 'cached'
        
    result = raw_submit_fuel(car, fuel, br)
    if result.find('You have already submitted this solution') != -1:
        cache[car] = fuel
        save_cache()
        if FAIL_ON_ASSERT:
            assert False, result
        return result

    if result.find('Good!') != -1:
        load_cache()
        cache[car] = fuel
        save_cache()
        return result
    else:
        print '========== Server fail ==========='
        if FAIL_ON_ASSERT:
            assert False, result
        return result


def list_cars():

    br = login()
            
    response = br.follow_link(text_regex=r".*Submit fuel.*")
    body = response.read()
    
    #print body
    #body = open('body').read()
    
    bs = BeautifulSoup(body)
    #print bs.prettify()
    #print bs.nextSibling.prettify()
    ids = []
    for tr in bs.fetch('tr'):
        if len(tr.fetch('td')) < 1:
            continue
        suppliers = str(tr.fetch('td')[1].contents[0])
        
        f = tr.fetch('form')[0]
        id = f.get('action')
        m = re.search(r"\/(\d+)\/", id)
        id = m.group(1)
        
        ids.append((id, suppliers))
    return ids
    
    
def get_cardata(br, car):
     
    if br == None:
        br = login()
    
    res = br.open("http://icfpcontest.org/icfp10/instance/{0}/solve/form".format(car))
     
    body = res.read()
     
    bs = BeautifulSoup(body)
    form = bs.fetch('form')[0]
    cardata = form.div.contents[1]
    return cardata

def load_cars():
    cars = open('data/car_ids').readlines()
    br = login()

    existing_cardata = open('data/car_data').readlines()

    for i, car in enumerate(cars):
        print>>sys.stderr, i,'/',len(cars)
        c, no = car.split(', ')
        
        found = False
        for ec in existing_cardata:
            existingid = ec.split(', ') 
            if existingid[0] == c:
                sys.stderr.write("skipping {0}\n".format(c))
                found = True
        if found:
            continue
        sys.stderr.write("fetching '{0}' of {1}\n".format(c, len(cars)))
        cardata = get_cardata(br, c)
        
        print "{0}, {1}".format(c, cardata)
        #time.sleep(2)
        
    return
        
            
if __name__ == '__main__':
    
    if len(sys.argv) < 2:
        print "use <vehicleid> <fuelfile or ->"
        print "or test <vehicledata> <fuelfile or -> (for test submits)"
        print "or listcars"
        print "or loadcars"
         
    else:
        if len(sys.argv) == 2:

            if sys.argv[1] == 'listcars':
                list = list_cars()
                for item in list:
                    print "{0}, {1}".format(item[0], item[1])
    
            if sys.argv[1] == 'loadcars':
                load_cars()

        else:
            if sys.argv[1] == 'test':
                car = sys.argv[2]
                if len(car) < 6:
                    data = csv.reader(open('../data/car_data'))
                    data = list(data)
                    for c in data:
                        if len(c) < 2:
                            continue
                        if int(c[0]) == int(car):
                            car = c[1].lstrip()
                            break
                    print car
                
                fuel = sys.argv[3]
                fuel = open(fuel).read()
                result = submit_test_car_fuel(car, fuel)
            else:
                vehicle = sys.argv[1]
                fuel = sys.argv[2]
                fuel = open(fuel).read()
                result = submit_fuel(vehicle, fuel)
                
            print
            print result
            print 
