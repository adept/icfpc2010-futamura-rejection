function findPermutes( inp )
    %FINDPERMUTES Summary of this function goes here
    %   Detailed explanation goes here
    
    [mainU, mainL, auxU, auxL]=getP(inp, 10);
    
    [mainU2, mainL2] = getP(inp(1:end-1), 1);
    
    mainU{length(mainU)+1} = mainU2{1};
    mainL{length(mainL)+1} = mainL2{1};
    
    sorting = [mainU2{1}' 6];
    
    % fuel
    S='[';
    for i = sorting
        S = [S '['];
        A = inp{i};
        for k = 1:length( inp{1} )
            S = [S mat2str( A(k,:) ) ','];
        end
        S = [S '],'];
        % disp([('[' + i -1) ' = ' mat2str( inp{i} ) ]);
    end
    S=strrep(strrep(S,'],]',']]'), ' ',',');
    S(end) = ']';
    disp(S);
    
    % car
    disp(num2str(round(rand*1e6)));
    disp(num2str(length(inp)));
    structure = [ones(1,length(mainU)) zeros(1,length(auxU))];
    if length(structure) > 6
        structure = structure(1:6);
    end
    disp(txt(structure));
    
    t = 0;
    for i = length(mainU):-1:1
        disp( txt( mainU{i}'-1 ) );
        disp( txt( mainL{i}'-1 ) );
        t=t+1;
        if t == 6, return,end
    end
    for i = length(auxU):-1:1
        disp( txt( auxU{i}'-1 ) );
        disp( txt( auxL{i}'-1 ) );
        t=t+1;
        if t == 6, return,end
    end
    
end

function [mainU, mainL, auxU, auxL]=getP(inp, limit)
    c=0;
    best = Inf;
    bestA = Inf;
    
    
    mainU = {};
    auxU  = {};
    
    mainL = {};
    auxL  = {};
    
    perm = perms( 1:length(inp) )';
    %     L = length(perm);
    %     perm(:, 1:L) = perm(:, randperm(L));
    %     perm = sortrows(perm);
    
    for p1 = perm
        for p2 = perm
            if isequal(p1, p2)
                continue
            end

            if isempty(p1) || isempty(p2)
                continue
            end
            
            diff = multt( inp(p1) ) - multt( inp(p2) );
            
            mn = min(min(diff));
            if mn > 0
                
                mx = max(max(diff));
                
                if mx < best
                    best = mx;
                    
                    mainU{length(mainU)+1} = p1;
                    mainL{length(mainL)+1} = p2;
                    c= c + 1;
                    if c==limit, return, end
                end
                
            elseif mn == 0
                mx = max(max(diff));
                
                if mx < bestA
                    bestA = mx;
                    
                    
                    auxU{length(auxU)+1} = p1;
                    auxL{length(auxL)+1} = p2;
                    c=c+1;
                    if c==limit, return, end
                end
            end
        end
    end
    if (c==0)
        error('fff');
    end
end

function s = txt(m)
    s = mat2str(m);
    s = strrep(s, ' ',',');
end

function acc = multt(M)
    acc = M{1};
    for m = M(2:length(M))
        acc = acc * m{1};
    end
end
