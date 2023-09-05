
function [NN, NE NR NL Node Element RestrainDoF FreeDoF Load]=infun(DEG)

finput = fopen('Q4Input.in','r');
Dummy = fgets(finput); Dummy = fgets(finput); Dummy = fgets(finput); 
Dummy = fgets(finput); Dummy = fgets(finput); Dummy = fgets(finput); 
Dummy = fgets(finput); Dummy = fgets(finput); Dummy = fgets(finput); 
% Preallocate all the matrixes

Temp = str2num(fgets(finput));

% NN = Number of Nodes
% NE = Number of Elements
% NR = Number of Restrained Degree of Freedoms
 

[NN, NE, NR ,NL] = deal(Temp(1), Temp(2), Temp(3),Temp(4));

Element=zeros(NE,9);
Node=zeros(NN,3);
RestrainDoF =zeros(2,NR);
FreeDoF=zeros(1,(DEG*NN)-NR);

% INPUT COORDINATES OF EACH NODE
Dummy = fgets(finput); Dummy = fgets(finput); Dummy = fgets(finput);
Dummy = fgets(finput); Dummy = fgets(finput);
for i = 1:NN
    Temp = str2num(fgets(finput));
    % Node= node matrix
    % Node(i,1) = Node Number
    % Node(i,2) = X-Coordinate of ith Node
    % Node(i,3) = Y-Coordinate of ith node
    Node(i,:)=deal(Temp);
    
end

% INPUT CONNECTIVITY, GEOMETRY DATA AND MATERIAL PROPERTIES
Dummy = fgets(finput); Dummy = fgets(finput); Dummy = fgets(finput);
Dummy = fgets(finput); Dummy = fgets(finput); 

for i=1:NE
    Temp = str2num(fgets(finput));
% Element= Element matrix
    % Element(i,1) = Element Number
    % Element(i,2) = Start Node of ith Element
    % Element(i,3) = 2nd Node of ith Element
    % Element(i,4) = 3rd Node of ith Element
    % Element(i,5) = 4th Node of ith Element
    % Element(i,6) = Material of ith Element
    % Element(i,7) = Thickness of ith Element
    % Element(i,8) = youngs modulus ith Element
    % Element(i,9) = poisson ratio ith Element
    [Element(i,1), Element(i,2), Element(i,3), Element(i,4),Element(i,5), ...
        Element(i,6),Element(i,7),Element(i,8),Element(i,9)] = deal(Temp(1), Temp(2), Temp(3), Temp(4), ...
        Temp(5), Temp(6), Temp(7),Temp(8),Temp(9));
      
end
% INPUT RESTRAINED DEGREE OF FREEDOM
Dummy = fgets(finput); Dummy = fgets(finput); Dummy = fgets(finput);
%RestrainDoF(1,:) is for free DOF Numbers
%RestrainDoF(2,:) is for free DOF Displacments
RestrainDoF(1,:) = str2num(fgets(finput));
RestrainDoF(2,:) = str2num(fgets(finput));

% EVALUATIONG FREE DEGREE OF FREEDOM
%they are used to get the free DOF for evaluationg the final K matrix
[m,n]=size(RestrainDoF);
loc=1;
k=1;
for i=1:1:DEG*NN
    for j=1:1:n
        if(i==RestrainDoF(1,j))
            loc=0;
        end
    end
    if(loc~=0)
        FreeDoF(1,k)=i;
            k=k+1;
    end
    loc=1;
end


% INPUT EXTERNAL LOADS ACTING ON PLANE TRUSS
        % Load = Loading on all Degree of Freedom
        % Load(rows) = The nmber of rows will be num ber of DOF
        %lOAD(Column)=The number of columns will be number of nodes

        Dummy = fgets(finput); Dummy = fgets(finput); Dummy = fgets(finput);
        Dummy = fgets(finput); Dummy = fgets(finput); Dummy = fgets(finput); 
        Dummy = fgets(finput);
        
        Load = zeros(NL,3);
        for i = 1:NL
            Temp = str2num(fgets(finput));
            [Load(i,1),Load(i,2),Load(i,3)] = deal(Temp(1), Temp(2),Temp(3));
           
        end

end





