clear;
I0 = imread('3.tif');

%RPE��ȡ
[m,n] = size(I0);
I1 = medfilt2(I0,[5, 5]); %��ֵ�˲�
I1 = imadjust(I1,[],[],1.5);
I2 = graythresh(I1);    %���ȫ����ֵ����
I3 = imbinarize(I1, I2+0.17); %��ֵ��
I4 = edge(I3,'canny'); 

%�߽�������ȡ
for j = 1:n
    ymin(j) = 1;
end

for i = m:-1:1
    for j = 1:n
        if(I4(i, j) == 1)
            if(i > ymin(j))
                ymin(j) = i;
            else
                I4(i,j)=0;
            end
        end
    end
end

%�������ͣ���ͨ��Ե
B1 = [0 0 0
      1 1 1
      0 0 0];
for i = 1:6
    I4 = imdilate(I4, B1);
end
B2 = [0 1 0
      1 1 1
      0 1 0];
for i = 1:4
    I4 = imdilate(I4, B2);
end

imLabel = bwlabel(I4);                %�Ը���ͨ����б��
stats = regionprops(imLabel,'Area');    %�����ͨ��Ĵ�С
area = cat(1,stats.Area);
index = find(area == max(area));        %�������ͨ�������
I4 = ismember(imLabel,index);          %��ȡ�����ͨ��ͼ��

%��ȡ�±߽�����
for j = 1:n
    ymin(j) = 1;
end

for i = m:-1:1
    for j = 1:n
        if(I4(i, j) == 1)
            if(i > ymin(j))
                ymin(j) = i;
            else
                I4(i,j)=0;
            end
        end
    end
end

k = 1;
for i = 1:m
    for j = n:-1:1
        if(I4(i,j) == 1)
            if(i == ymin(j))
                yV(k) = i;
                xV(k) = j;
                k = k + 1;
            end
        end
    end
end

imshow(I0);
hold on;

%���Ʊ߽�
pV = polyfit(xV, yV, 10);
y1V = polyval(pV, xV);
xxV = linspace(1, n, 300);
yyV = spline(xV, y1V, xxV);
plot(xxV, yyV-4, '-', 'LineWidth', 1, 'color', 'b');
legend('Vitreous');