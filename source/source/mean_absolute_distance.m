function MAD = mean_absolute_distance(m1,m2)
    d=size(m1,1)*size(m1,2)*size(m2,1)*size(m2,2);
    s=0;
    for i=1:size(m1,1)
        for j=1:size(m1,2)
            s=s+abs(m2(i,j)-m1(i,j));
        end
    end
    MAD=s/d;
end

