clear;
I0 = imread('11.tif');

%GCL��ȡ
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

%I3 = imfill(I3,'holes');
%��ȡ�ײ�����
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

% I4 = edge(I3,'canny'); %��Ե��ȡ
%imshow(I3);
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

imshow(I0);
hold on
pG = polyfit(xG, yG, 6);
y1G = polyval(pG, xG);
xxG = linspace(1, n);
yyG = spline(xG, y1G, xxG);
plot(xxG, yyG, '-', 'LineWidth', 1, 'color', 'y');%������ϻ���
legend('GCL');