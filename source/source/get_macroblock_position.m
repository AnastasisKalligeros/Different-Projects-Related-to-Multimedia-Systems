function [xi,yi] = get_macroblock_position(number,scale)
    if(scale==0)
        scale=1;
    end
    x=320/scale;
    step=64/scale;
    count=1;
    for i=1:step:x
        for j=1:step:x
            if(count==number)
                xi=i;
                yi=j;
                return
            end
            count=count+1;
        end
    end
end

