clear;
I0 = imread('9.tif');

%Vitreous��ȡ
[m,n] = size(I0);
I1 = medfilt2(I0,[5, 5]); %��ֵ�˲�
thresh = graythresh(I1);    %���ȫ����ֵ����
I2 = imbinarize(I1, thresh); %��ֵ��
I3 = edge(I2,'canny'); %��Ե��ȡ

%�߽�������ȡ
for j = 1:n
    ymin(j) = m;
end

for i = 1:m
    for j = 1:n
        if(I3(i, j) == 1)
            if(i < ymin(j))
                ymin(j) = i;
            elseif(i < ymin(j) + 10 && j ~= 2)
                if(I3(i, j+1) == 1 && I3(i, j-1) == 1)
                    I3(i,j) = 0;
                end
            else
                I3(i,j)=0;
            end
        end
    end
end

k = 1;
for i = 1:m
    for j = 1:n
        if(I3(i,j) == 1)
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
V=plot(xxV, yyV, '-', 'LineWidth', 1, 'color', 'b');

%RPE��ȡ
[m,n] = size(I0);
I1 = medfilt2(I0,[5, 5]); %��ֵ�˲�
I1 = imadjust(I1,[],[],1.5);
thresh = graythresh(I1);    %���ȫ����ֵ����
I2 = imbinarize(I1, thresh+0.17); %��ֵ��
I3 = edge(I2,'canny'); 

%�߽�������ȡ
for j = 1:n
    ymin(j) = 1;
end

for i = m:-1:1
    for j = 1:n
        if(I3(i, j) == 1)
            if(i > ymin(j))
                ymin(j) = i;
            else
                I3(i,j)=0;
            end
        end
    end
end

B1 = [0 0 0
      1 1 1
      0 0 0];
for i = 1:6
    I3 = imdilate(I3, B1);
end
B2 = [0 1 0
      1 1 1
      0 1 0];
for i = 1:4
    I3 = imdilate(I3, B2);
end

imLabel = bwlabel(I3);                %�Ը���ͨ����б��
stats = regionprops(imLabel, 'Area');    %�����ͨ��Ĵ�С
area = cat(1, stats.Area);
index = find(area == max(area));        %�������ͨ�������
I3 = ismember(imLabel, index);          %��ȡ�����ͨ��ͼ��

for j = 1:n
    ymin(j) = 1;
end

for i = m:-1:1
    for j = 1:n
        if(I3(i, j) == 1)
            if(i > ymin(j))
                ymin(j) = i;
            else
                I3(i,j)=0;
            end
        end
    end
end

k = 1;
for i = 1:m
    for j = 1:n
        if(I3(i,j) == 1)
            if(i == ymin(j))
                yR(k) = i;
                xR(k) = j;
                k = k + 1;
            end
        end
    end
end

%���Ʊ߽�
pR = polyfit(xR, yR, 10);
y1R = polyval(pR, xR);
xxR = linspace(1, n, 300);
yyR = spline(xR, y1R, xxR);
R=plot(xxR, yyR-4, '-', 'LineWidth', 1, 'color', 'm');

%NFL��ȡ
I1=histeq(I0); 
thresh = graythresh(I1);    %���ȫ����ֵ����
I2 = imbinarize(I1, thresh+0.46); %��ֵ��

[m,n]=size(I2);

for j = 1:n
    for i = 1:m
        if(I2(i, j) == 1)
            for k = i+20:m
                I2(k, j) = 0;
            end
        end
    end
end

%ȷ����һ����
for i = 1:m
    if(I2(i, j) == 1)
        k = i;
    end
end

%ȥ���·�����ĵ�
for j = 1:n
    for i = k+140:m
        I2(i, j) = 0;
    end
end

%��������ͨ
I3 = imclose(I2, ones(3)); 

%��ȡ�ײ�����
for j = 1:n
    for i = 1:m
        if (I3(i, j) == 1 && I3(i+1, j) == 1)
            I3(i, j) = 0;
        elseif (I3(i, j) == 1 && I3(i+1, j) == 0) %ȥ���ײ������ӵ�
            for k = i+1:m
                I3(k, j) = 0;
            end
        end
    end
end

I4 = I3;

%��ͼ
for j = 1:n
    ymax(j) = 1;
end
for i = 1:m
    for j = 1:n
        if(I4(i,j) == 1)
            if(i > ymax(j))
                ymax(j) = i;
            end
        end
    end
end

k = 1;
for i = 1:m
    for j = 1:n
        if(I4(i,j) == 1)
            if(i == ymax(j))
                yN(k) = i;
                xN(k) = j;
                k = k+1;
            end
        end
    end
end

pN = polyfit(xN, yN, 8);
y1N = polyval(pN, xN);
xxN = linspace(1, n);
yyN = spline(xN, y1N, xxN);
N = plot(xxN, yyN, '-', 'LineWidth', 1, 'color', 'g');%������ϻ���

legend([V,N,R],'Vitreous','NFL','RPE');