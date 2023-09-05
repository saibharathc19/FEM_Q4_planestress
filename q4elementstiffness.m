function [Kel] =q4elementstiffness(Element,Node,DEG,NE)

NIP=4;
%NUMBER OF INTEGRATION POINTS
% This is calcualted as per the plane stress element
XNI=zeros(NIP,2);
Kel=zeros(8,8,NE);
XNI=[-.57735 -.57735;.57735 -.57735;.57735 .57735 ;-.57735 .57735];
%THEY ARE GIVEN IN ANTICLOCKWISE ORDER
%THEY WILL BE GIVING INPUT TO XI AND ETA
J=zeros(2,2);
G=zeros(4,8);

for i=1:NE
    E=Element(i,8);
    NU=Element(i,9);
    %D=[1 NU 0;NU 1 0;0 0 (1-NU)*.5]*(E/(1-(NU*NU)));
    D=[(1-NU) NU 0;NU (1-NU) 0; 0 0 (.5-NU)]*(E/((1+NU)*(1-2*NU)));

    for IP=1:NIP
        XI=XNI(IP,1);
        ETA=XNI(IP,2);
        k1=1-XI;
        k2=1+XI;
        k3=1-ETA;
        k4=1+ETA;
        T=Element(i,6);
        % Formation of Jacobian Matrix
        J(1,1)=0.25*(-(1-ETA)*Node(Element(i,2),2)+(1-ETA)*Node(Element(i,3),2)+(1+ETA)*Node(Element(i,4),2)-(1+ETA)*Node(Element(i,5),2));
        J(1,2)=0.25*(-(1-ETA)*Node(Element(i,2),3)+(1-ETA)*Node(Element(i,3),3)+(1+ETA)*Node(Element(i,4),3)-(1+ETA)*Node(Element(i,5),3));
        J(2,1)=0.25*(-(1-XI)*Node(Element(i,2),2)-(1+XI)*Node(Element(i,3),2)+(1+XI)*Node(Element(i,4),2)+(1-XI)*Node(Element(i,5),2)); 
        J(2,2)=0.25*(-(1-XI)*Node(Element(i,2),3)-(1+XI)*Node(Element(i,3),3)+(1+XI)*Node(Element(i,4),3)+(1-XI)*Node(Element(i,5),3)); 
        J;
        A=zeros(3,4);
        d=det(J);
        A(1,1)=J(2,2);
        A(1,2)=-J(1,2);
        A(2,3)=-J(2,1);
        A(2,4)=J(1,1);
        A(3,1)=-J(2,1);
        A(3,2)=J(1,1);
        A(3,3)=J(2,2);
        A(3,4)=-J(1,2);
        A=(1/d)*A;
        G=0.25*[-k3 0 k3 0 k4 0 -k4 0;-k1 0 -k2 0 k2 0 k1 0;0 -k3 0 k3 0 k4 0 -k4;0 -k1 0 -k2 0 k2 0 k1];
        
        B=A*G;
        

        Kel(:,:,i)=Kel(:,:,i)+((transpose(B))*D*B*d*Element(i,7));
    end
    
end
        
        
        
        

        
        
