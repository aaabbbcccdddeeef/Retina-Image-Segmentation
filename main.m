clear;
I0 = imread('1.tif');

%*****************************************%
%               Vitreous��ȡ
%*****************************************%

[m,n] = size(I0);
I1 = medfilt2(I0,[5, 5]); %��ֵ�˲�
thresh = graythresh(I1); %���ȫ����ֵ����
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
V = plot(xxV, yyV, '-', 'LineWidth', 1, 'color', 'b');

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

%*****************************************%
%                 GCL��ȡ
%*****************************************%

[m,n] = size(I0);
I1 = medfilt2(I0,[5, 5]); %��ֵ�˲�
thresh = graythresh(I1);    %���ȫ����ֵ����
I2 = imbinarize(I1, thresh+0.08); %��ֵ��

I3 = imclose(I2, ones(5));

for j = 1:n
    for i = 1:m
        if I3(i, j) == 1
            for k = i+100:m
                I3(k, j) = 0;
            end
        end
    end
end

%�ж��Ƿ��°�
for i = 1:m
    if I3(i, 50) == 1
        imin = i;
        break;
    end
end

for i = 1:m
    if I3(i, 150) == 1
        imax = i;
        break;
    end
end

if imax - imin > 60
    %ȥ�����ζ����ɫ����
    for j = 1:n
        for k = imin+120:m
            I3(k, j) = 0;
        end
    end
    I3 = medfilt2(I3,[2, 2]); %��ֵ�˲�
    %��1
    for i = m:-1:1
        if I3(i, 80) == 1
            del = i;
            break;
        end
    end
    for j = 1:80
        for k = del-30:del
            I3(k, j) = 0;
        end
    end
    %��2
    for i = m:-1:1
        if I3(i, 120) == 1
            del = i;
            break;
        end
    end
    for j = 80:140
        for k = del-15:del+20
            I3(k, j) = 0;
        end
    end
    %��1
    for i = m:-1:1
        if I3(i, 160) == 1
            del = i;
            break;
        end
    end
    for j = 180:220
        for k = del-8:del+20
            I3(k, j) = 0;
        end
    end
    %��2
    for i = m:-1:1
        if I3(i, 240) == 1
            del = i;
            break;
        end
    end
    for j = 220:260
        for k = del-20:del+20
            I3(k, j) = 0;
        end
    end
    %��3
    for j = 260:300
        for k = del-30:del+20
            I3(k, j) = 0;
        end
    end
else
    imLabel = bwlabel(I3); %�Ը���ͨ����б��
    stats = regionprops(imLabel,'Area'); %�����ͨ��Ĵ�С
    area = cat(1,stats.Area);
    index = find(area == max(area)); %�������ͨ�������
    I3 = ismember(imLabel,index); %��ȡ�����ͨ��ͼ�� 
    %��Ե�10��ͼ��Ҫ����ɾ����������
    for j = 1:n
        for i = 1:m
            if I3(i, j) == 1
                for k = i+70:m
                    I3(k, j) = 0;
                end
            end
        end
    end
end

%��ȡ�±߽�����
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
                yG(k) = i;
                xG(k) = j;
                k = k+1;
            end
        end
    end
end

pG = polyfit(xG, yG, 8);
y1G = polyval(pG, xG);
xxG = linspace(1, n);
yyG = spline(xG, y1G, xxG);
G = plot(xxG, yyG, '-', 'LineWidth', 1, 'color', 'y');%������ϻ���

%*****************************************%
%                 OPL��ȡ
%*****************************************%

[m,n] = size(I0);
I1 = medfilt2(I0,[5, 5]); %��ֵ�˲�
thresh = graythresh(I1);    %���ȫ����ֵ����
I2 = imbinarize(I1, thresh-0.06); %��ֵ��
I2 = imopen(I2, ones(6));
I2 = imclose(I2, ones(6));
I2 = imopen(I2, ones(15));
I2 = medfilt2(I2,[6, 6]); %��ֵ�˲�
for j = 1:n
    for i = 1:m
        if(I2(i, j) == 1)
            for k = i+110:m
                I2(k, j) = 0;
            end
        end
    end
end

%�ж��Ƿ��°�
for i = 1:m
    if I2(i, 50) == 1
        imin = i;
        break;
    end
end

for i = 1:m
    if I2(i, 150) == 1
        imax = i;
        break;
    end
end

if imax - imin > 60
    %ȥ�����ζ����ɫ����
    for i = m:-1:1
        if I2(i, 160) == 1
            ymax = i;
            break;
        end
    end
    for j = 1:n
        for k = ymax-100:ymax+20
            I2(k, j) = 0;
        end
    end
end

B1 = [1 1 1
      1 1 1
      0 0 0];
for i = 1:8
    I2 = imdilate(I2, B1);
end

I3 = edge(I2,'canny'); 
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
                yOP(k) = i;
                xOP(k) = j;
                k = k+1;
            end
        end
    end
end

pOP = polyfit(xOP, yOP, 6);
y1OP = polyval(pOP, xOP);
xxOP = linspace(1, n);
yyOP = spline(xOP, y1OP, xxOP);
OP = plot(xxOP, yyOP, '-', 'LineWidth', 1, 'color', 'c');%������ϻ���

%*****************************************%
%                 ONL��ȡ
%*****************************************%

[m,n] = size(I0);
I1 = medfilt2(I0,[5, 5]); %��ֵ�˲�
thresh = graythresh(I1);    %���ȫ����ֵ����
I2 = imbinarize(I1, thresh+0.15); %��ֵ��

B1 = [0 0 0
      1 1 1
      0 0 0];
for i = 1:6
    I2 = imdilate(I2, B1);
end
I2 = imopen(I2, ones(5));

for j = 1:n
    for i = m:-1:1
        if(I2(i, j) == 1)
            for k = i-75:-1:1
                I2(k, j) = 0;
            end
        end
    end
end

%ȷ����һ����
for i = m:-1:1
    if(I2(i, j) == 1)
        k = i;
    end
end

%ȥ���·�����ĵ�
for j = 1:n
    for i = k-90:-1:1
        I2(i, j) = 0;
    end
end

I2 = imclose(I2, ones(3)); 
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
                yON(k) = i;
                xON(k) = j;
                k = k + 1;
            end
        end
    end
end

%���Ʊ߽�
pON = polyfit(xON, yON, 8);
y1ON = polyval(pON, xON);
xxON = linspace(1, n, 300);
yyON = spline(xON, y1ON, xxON);
ON=plot(xxON, yyON, '--', 'LineWidth', 1, 'color', 'b');

%*****************************************%
%                 OS��ȡ
%*****************************************%

[m,n] = size(I0);
I1=histeq(I0); 
thresh = graythresh(I1); %���ȫ����ֵ����
I2 = imbinarize(I1, thresh+0.47); %��ֵ��
I2 = medfilt2(I2,[6,6]); %��ֵ�˲�

for j = 1:n
    for i = m:-1:1
        if(I2(i, j) == 1)
            for k = i-10:-1:1
                I2(k, j) = 0;
            end
        end
    end
end

%ȷ����һ����
for i = 1:m
    for j = 1:n
     if(I2(i,j)==1 && i>k)
         k=i;
     end
    end
end

%ȥ���Ϸ�����ĵ�
for j = 1:n
    for i = k-70:-1:1
        I2(i, j) = 0;
    end
end

I3 = edge(I2,'canny'); 

B1 = [0 1 0
      1 1 1
      0 1 0];
for i = 1:1
    I3 = imdilate(I3, B1);
end

%�߽�������ȡ
for j = 1:n
    ymin(j) = m;
end

for i = 1:m
    for j = 1:n
        if(I3(i, j) == 1)
            if(i < ymin(j))
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
                yOS(k) = i;
                xOS(k) = j;
                k = k + 1;
            end
        end
    end
end

%���Ʊ߽�
pOS = polyfit(xOS, yOS, 10);
y1OS = polyval(pOS, xOS);
xxOS = linspace(1, n, 300);
yyOS = spline(xOS, y1OS, xxOS);
OS = plot(xxOS, yyOS, '--', 'LineWidth', 1, 'color', 'y');

%*****************************************%
%                 RPE��ȡ
%*****************************************%

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
yyR = spline(xR, y1R, xxR)-4;
R = plot(xxR, yyR, '--', 'LineWidth', 1, 'color', 'm');

legend([V, N, G, OP, ON, OS, R], 'Vitreous', 'NFL', 'GCL', 'OPL', 'ONL', 'OS', 'RPE');