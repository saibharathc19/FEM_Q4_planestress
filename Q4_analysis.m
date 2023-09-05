%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%            MATLAB PROGRAM FOR THE ANALYSIS Q4 BILINEAR ELEMENT          %
%                ===========================================              %
%                  WRITTEN BY:CHAPPARAM SAI BHARATH                       %
%                    DEPT. OF CIVIL ENGINEERING                           %
%                  BHABHA ATOMIC RESEARCH CENTRE                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Geting the input from the function infun with DEG as input argument
clear all
clc
format long
DEG=2;
%DEG= Number of DOF at every node
%All dimensions are in mm or N/mm2 unless otherwise specified
%% INPUT DATA REQUIRED FOR THE PROGRAM %%

[NN NE NR NL Node Element RestrainDoF FreeDoF Load]=infun(DEG);
% NN = Number of Nodes
% NE = Number of Elements
% NR = Number of Restrained Degree of Freedoms
% Node= node matrix
    % Node(i,1) = Node Number
    % Node(i,2) = X-Coordinate of ith Node
    % Node(i,3) = Y-Coordinate of ith node
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
%% ELEMENT STIFFNESS MATRIX %%

[Kel] =q4elementstiffness(Element,Node,DEG,NE);
Keg=Kel;
%Kel,Keg= Three dimensional array storing the Stiffness matrix of all elements

%% ASSEMBLY STIFFNESS MATRIX %%

Kadd =q4elementAssemble(Keg,NE,DEG,NN,Element);
GStiffness=Kadd;
%Kadd= Global assembly stiffness matrix based on the connectivity of the elements
%% ASSIGNINMENT OF BOUNDARY CONDITIONS %%

[GStiffnessBC,Kff,Kfc,Kcf,Kcc,X] =q4elementStiffnessAssign(Kadd,DEG,NN,RestrainDoF,FreeDoF);
% GStiffnessBC = Global Stiffness Matrix Applying Boundary Condition;
tf = isequal(X,GStiffnessBC);
%tf            =verifying whether bothGstiffness and X are equal
% GStiffnessBC = Global Stiffness Matrix Applying Boundary Condition;
% X            = Global Stiffness Matrix after Applying Kff,Kcc,Kfc,Kcf;


 %% ASSIGNMENT OF LOADS ON THE RESPECTIVE DOF %%  

% LoadBC = Loadings After Applying Boundary Conditions
LoadBC=zeros(DEG*NN,2);
         
for j=1:1:DEG*NN
LoadBC(j,1)=j;
end

r=1;
for j=1:1:NL
    LoadBC(2*(Load(j,1))-1,2)=Load(j,2);
    LoadBC(2*(Load(j,1)),2)=Load(j,3);

end
        
 LoadBC(RestrainDoF(1,:),:)=[];
 
 %% ANALYSIS OF THE STRUCTURE %%
    
%Free DOF displacement
%taking the of settlement in the bellow term
u=(Kfc*(RestrainDoF(2,:).'));
Kff;
%FINDING THE DISPLACEMENT AT UNCONSTRAINED NODES
DispUnConstrained= Kff\(LoadBC(:,2)-u);
Uf(:,1)=FreeDoF;
Uf(:,2)=(DispUnConstrained);
Uc(:,1)=(RestrainDoF(1,:).');
Uc(:,2)=(RestrainDoF(2,:).');

%DispUnConstrained = Displacement corresponding to UnRestrained DOF
%Uf= Matrix containg free displacement to respective DOF 
%Uf(:,1)=Free DOF
%Uf(:,2)=Free DOF Displacement
%Uc(:,1)=Restrained DOF
%Uc(:,2)=Restrained DOF Displacement
% GNoadalDisp = Global Nodal Displacements
% Reaction = Horizontal and Vertical Reactions at each Node
% ElementForce = Force on Each Element of the member
% Sigma = Stress on each element

U=[Uf;Uc];
% PLACING THE DISPLACEMENT AT EVERY NODE IN ASCENDING ORDER AS PER
% DOF AND IN DISPLACEMENT MATRIX
Displacement=zeros(DEG*NN,2);
m=1;
for i=1:1:NN*DEG
    for j=1:1:NN*DEG
        if(U(j,1)==i)
            Displacement(m,2)=U(j,2);
            Displacement(m,1)=m;
            m=m+1;
        end
    end
end
        
Rf(:,2)=X*U(:,2);
Rf(:,1)=U(:,1);
ReactionForce=zeros(DEG*NN,2);
m=1;
for i=1:1:NN*DEG
    for j=1:1:NN*DEG
        if(Rf(j,1)==i)
            ReactionForce(m,2)=Rf(j,2);
            m=m+1;
        end
    end
end
%% EVALUATION OF STRESS %%
        
%         Stress is evaluated at gauss point
[sigma] = q4elementstress(Element,Node,DEG,NE,NN,Displacement)
        

       

 