function lines=AG3line( imagefolder,picstr )
counterl=0;
lines=zeros(1000,4);

addpath('funcs/');
gradthreshold=5.2;%ȫ���ݶ���ֵ
minradius2=10;
minradius1=3;

%���ݶ�ȡ����
im=imread([imagefolder picstr]);
%�ܶ��жϵ���������
p1=117.8;
p2= -2.465 ;
p3=  0.6996 ;

grayim=im;
try
    grayim=rgb2gray(grayim);
catch
end


h=fspecial('gaussian',[5 5],1);
grayim=filter2(h,grayim);
hx=[-1 1
    -1 1];
hy=[-1 -1
    1 1];

%%�ݶ� �нǼ���

gx=filter2(hx,grayim);
gy=filter2(hy,grayim);
grad=sqrt(gx.^2+gy.^2);
grad(grad<gradthreshold)=0;
ang= atan2(gx, -gy);

anchor=exttractAnchor1(grad,ang,1,1);

[m,n]=size(ang);
[ys,xs]=find(anchor>0);
[~,idx]=sort(grad((xs-1)*m+ys),'descend');

%�������ݽṹ
usedmat=zeros(m,n);
segs=zeros(int32((m+n)/2),2);

Mdl = createns([xs,ys]);
N=m;
if(n<m)
    N=n;
end
minlength=-4*log(N)/log(0.125);
counterthre=minlength*0.9;%����anchor

for i= 1:size(idx,1)%13110:13110%
    C=0;
    
    yy=ys(idx(i));
    xx=xs(idx(i));
    %����anchor1��Ϊ����anchor
    if anchor(yy,xx)==1
        continue;
    end
    %�Ѿ������� ��ѭ��
    if usedmat(yy,xx)==1
        continue;
    end
    
    usedmat(yy,xx)=1;
    sumdx=cos(ang(yy,xx));
    sumdy=sin(ang(yy,xx));
    segang=atan2(sumdy,sumdx);
    
    dirx=cos(ang(yy,xx));
    diry=sin(ang(yy,xx));
    counter=1;
    segs(counter,:)=[xx,yy];
    
    %��ʼ��ѭ��Ҫ��
    mx=xx;
    my=yy;
    a=1;
    C=(1-a)*(C+a*([xx;yy])*([xx;yy])');
    n=1;
    
    
    while n<=counter
        %���Ʒ���
        xx=segs(n,1);
        yy=segs(n,2);
        %��kd�����ؽǵ�
        IdxNN = rangesearch(Mdl,[xx,yy],minradius2);
        
        if isempty(IdxNN)
            continue;
        end
        IdxNN=IdxNN{1};
       
        for ii=1:size(IdxNN ,2)
            x1=xs(IdxNN(ii));y1=ys(IdxNN(ii));
            
            if usedmat(y1,x1)==1
                continue;
            end
            
             dispts=norm([x1-xx y1-yy]);
           if anchor(y1,x1)==1&&dispts>minradius1
               continue;
           end
            
            pt=[x1,y1,0];
            v1=[mx,my,0];
            v2=[mx+10*dirx,my+10*diry,0];
            
            d = point_to_line(pt, v1, v2);
            if(d>1.00000001)
                continue;
            end
            
           lineang=ang(y1,x1);
            % ������� anchor1 ���Ƕ��Ƿ����
            angaligned=abs(angdiff(segang,lineang))<=pi/8;
            if ~((counter>minlength&&dispts<=1&&d<=0.5)||angaligned)
                continue;
            end
            
            %ȷ������  ����segang
            counter=counter+1;
            segs(counter,:)=[x1,y1];
            usedmat(y1,x1)=1;
            
            if angaligned
                sumdx=sumdx+cos(ang(y1,x1));
                sumdy=sumdy+sin(ang(y1,x1));
                segang=atan2(sumdy,sumdx);
            end
            
            %�����ֵ��Э�������
            a=1/counter;
            C=(1-a)*(C+a*([x1;y1]-[mx;my])*([x1;y1]-[mx;my])');
            mx=(1-a)*mx+a*x1;
            my=(1-a)*my+a*y1;
            
            %�����С����ֵ
            lambda=0.5*(C(1,1)+C(2,2)-...
                sqrt((C(1,1)-C(2,2))^2+4*C(1,2)*C(1,2)));
            
            if(C(1,1)>C(2,2))
                theta=atan2(lambda-C(1,1),-C(1,2));
            else
                theta=atan2(-C(1,2),lambda-C(2,2));
            end
            if (angdiff(theta, segang) > pi/8)
                theta = theta+pi;
            end
            dirx=sin(theta);
            diry=cos(theta);
        end
        n=n+1;
    end
    
    
    %��anchor ����������
    if counter<counterthre
        %         for ii=1:counter
        %             usedmat(segs(ii,2),segs(ii,1))=0;
        %         end
        continue;
    end
    
    
    %�������� ���ݽǶ�ȷ����x��y����
    if is_go_horizon(segang)
        [~,idx1]=sort(segs(1:counter,1));
    else
        [~,idx1]=sort(segs(1:counter,2));
    end
    line=linefitSVD(segs,counter,mx,my,dirx,diry);
    if norm(line(1:2)-line(3:4))<minlength
        continue;
    end
    
    %     plot([line(1),line(3)],[line(2),line(4)], 'Color','black','LineWidth',2);
    %     continue;
    segs(1:counter,:)=segs(idx1,:);
    
    
    %�鿴���ȱ仯
    %��ȡ�߶�����
    if abs(line(1)-line(3))>abs(line(2)-line(4))
        lxs=linspace(line(1),line(3),abs(line(1)-line(3))+1);
        lys=linspace(line(2),line(4),abs(line(1)-line(3))+1);
    else
        lxs=linspace(line(1),line(3),abs(line(2)-line(4))+1);
        lys=linspace(line(2),line(4),abs(line(2)-line(4))+1);
    end
    lxs=round(lxs);
    lys=round(lys);

    
    %��anchor��Ӧ�ľ�������ĵط�
    minidx=zeros(size(lxs,2),1);
    for ii=1:counter
        md=99;
        ax=segs(ii,1);ay=segs(ii,2);
        for jj=1:size(lxs,2)
            dd=norm([ax-lxs(jj) ay-lys(jj)]);
            if dd<md
                md=dd;
                idd=jj;
            end
        end
        minidx(idd)=1;
    end
    
    
    linelen=norm(line(1:2)-line(3:4));
    dthre=p1 *linelen^p2 +p3  ;
    try
    [st,ed,~] = splitByAnchor(minidx,1,size(minidx,1),minlength,dthre);
    catch
       continue;
    end
    %     st=1;
    %     ed=size(minidx,1);
    if st==0
        continue;
    end
    if st~=1||ed~=size(minidx,1)
        %��ȡ��anchor������� ����ԭδ���anchor
        %����Ѱ�������anchor
        mindisst=999;
        mindised=999;
        xst=lxs(st);yst=lys(st);
        xed=lxs(ed);yed=lys(ed);
        for ii=1:counter
            %��������
            if  norm([xst-segs(ii,1) yst-segs(ii,2)])<mindisst
                mindisst=norm([xst-segs(ii,1) yst-segs(ii,2)]);
                stid=ii;
            end
            if  norm([xed-segs(ii,1) yed-segs(ii,2)])<mindised
                mindised=norm([xed-segs(ii,1) yed-segs(ii,2)]);
                edid=ii;
            end
        end
        
        if stid>edid
            temp=stid;
            stid=edid;
            edid=temp;
        end
        %���¼���
        line = fitLineByAhchor(segs(stid:edid,:),segang);
        %��ԭδʹ��anchor
        for ii=1:stid
            usedmat(segs(ii,2),segs(ii,1))=0;
        end
        for ii=edid:counter
            usedmat(segs(ii,2),segs(ii,1))=0;
        end
    end
    
    try
    [line,usedmat,~] = refineByAnchor(line,segs(1:counter,:),segang,grad,usedmat,minlength);
    catch
        continue;
    end
    if line(1)==0
        continue;
    end
    
    counterl=counterl+1;
  
    lines(counterl,:)=line;
    plot([line(1),line(3)],[line(2),line(4)], 'Color','black','LineWidth',2);
    
end%�����߾ʹ˽���
lines=lines(1:counterl,:);
end




