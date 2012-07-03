function [  ] = visualizeData( w,data,idx )

colors='rgbym';

n = size(w,2);

hold on;

for i = 1:n
    scatter(w(1,i),w(2,i),'filled',colors(i));
    selection = data(:,idx==i);
    scatter(selection(1,:),selection(2,:),colors(i));
end

hold off;

end

