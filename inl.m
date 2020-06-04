clear;
I0 = imread('3.tif');

%INL��ȡ
[m,n] = size(I0);
I1 = medfilt2(I0,[5, 5]); %��ֵ�˲�
thresh = graythresh(I1); %���ȫ����ֵ����
I2 = imbinarize(I1, thresh+0.05); %��ֵ��
I2 = medfilt2(I2,[3, 3]);

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
        for k = ymax-90:ymax+50
            I2(k, j) = 0;
        end
    end
end

for j = 1:n
    for i = m:-1:1
        if (I2(i, j) == 1 && I2(i-1, j) == 1)
            I2(i, j) = 0;
        elseif (I2(i, j) == 1 && I2(i-1, j) == 0) %ȥ���ײ������ӵ�
            for k = i-1:-1:1
                I2(k, j) = 0;
            end
        end
    end
end

for j = 11:n-5
    for i = m:-1:1
        if I2(i, j) == 1
            for t = i-25:-1:1
                for k = j-10:j+10
                    I2(t, k) = 0;
                end
            end
        end
    end
end
                

for j = 1:n
    ymin(j) = 1;
end

for i = m:-1:1
    for j = 1:n
        if(I2(i, j) == 1)
            if(i > ymin(j))
                ymin(j) = i;
            else
                I2(i,j)=0;
            end
        end
    end
end

% I4 = edge(I3,'canny'); %��Ե��ȡ
%imshow(I3);
k = 1;
for i = 1:m
    for j = 1:n
        if(I2(i,j) == 1)
            if(i == ymin(j))
                yIN(k) = i;
                xIN(k) = j;
                k = k+1;
            end
        end
    end
end

imshow(I0);
hold on
pIN = polyfit(xIN, yIN, 7);
y1IN = polyval(pIN, xIN);
xxIN = linspace(1, n);
yyIN = spline(xIN, y1IN, xxIN);
plot(xxIN, yyIN, '-', 'LineWidth', 1, 'color', 'm');%������ϻ���
legend('INL');