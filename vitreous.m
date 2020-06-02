clear;
I0 = imread('5.tif');

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
plot(xxV, yyV, '-', 'LineWidth', 1, 'color', 'b');
legend('Vitreous');