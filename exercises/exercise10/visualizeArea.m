function [  ] = visualizeArea( w,xB,yB )

resolution=0.01;
k=size(w,2);

X = xB(1):resolution:xB(2);
Y = yB(1):resolution:yB(2);

[mX,mY] = meshgrid(X,Y);

vY=reshape(mY,numel(mY),1);
vX=reshape(mX,numel(mX),1);

data=[vX,vY]';

dist = sqrt((repmat(w(1,:),length(data),1)-repmat(data(1,:)',1,k)).^2+...
    (repmat(w(2,:),length(data),1)-repmat(data(2,:)',1,k)).^2);

[values,idx] = min(dist,[],2);


idx=reshape(idx,numel(Y),numel(X));

imagesc(vX,vY,idx);
set(gca,'Ydir','normal');

end

