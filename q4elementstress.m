function [sigma] =q4elementstress(Element,Node,DEG,NE,NN,Displacement)

X=zeros(4*DEG,2);
NIP=1;
XNI=zeros(NIP,2);
sigma=zeros(3,NE);
J=zeros(2,2);
G=zeros(4,8);
for l=1:NE
X(1,1)=(Element(l,2)*2)-1;
X(2,1)=(Element(l,2)*2);
X(3,1)=(Element(l,3)*2)-1;
X(4,1)=(Element(l,3)*2);
X(5,1)=(Element(l,4)*2)-1;
X(6,1)=(Element(l,4)*2);
X(7,1)=(Element(l,5)*2)-1;
X(8,1)=(Element(l,5)*2);



        
        for i=1:1:4*DEG
            for j=1:1:NN*DEG
                if(Displacement(j,1)==X(i,1))
                    X(i,2)=Displacement(j,2);
                    
                end
            end
        end
X;
    E=Element(l,8);
    NU=Element(l,9);
    D=[1 NU 0;NU 1 0;0 0 (1-NU)*.5]*(E/(1-(NU*NU)));
    %D=[(1-NU) 0 0;0 (1-NU) 0; 0 0 (1-NU)]*(E/((1+NU)*(1-2*NU)));

    
        XI=0;
        ETA=0;
        k1=1-XI;
        k2=1+XI;
        k3=1-ETA;
        k4=1+ETA;
        T=Element(l,6);
        % Formation of Jacobian Matrix
        J(1,1)=0.25*(-(1-ETA)*Node(Element(l,2),2)+(1-ETA)*Node(Element(l,3),2)+(1+ETA)*Node(Element(l,4),2)-(1+ETA)*Node(Element(l,5),2));
        J(1,2)=0.25*(-(1-ETA)*Node(Element(l,2),3)+(1-ETA)*Node(Element(l,3),3)+(1+ETA)*Node(Element(l,4),3)-(1+ETA)*Node(Element(l,5),3));
        J(2,1)=0.25*(-(1-XI)*Node(Element(l,2),2)-(1+XI)*Node(Element(l,3),2)+(1+XI)*Node(Element(l,4),2)+(1-XI)*Node(Element(l,5),2)); 
        J(2,2)=0.25*(-(1-XI)*Node(Element(l,2),3)-(1+XI)*Node(Element(l,3),3)+(1+XI)*Node(Element(l,4),3)+(1-XI)*Node(Element(l,5),3)); 
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
      

        sigma(:,l)=(D*B*X(:,2));
    
end
        
        
        
        

        
        
