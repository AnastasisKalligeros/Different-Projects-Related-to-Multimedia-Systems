function frame = search(f1,f2)
%function for hierarchical searsh
    m=64;
    k=32;
    %highest level variables
    ku=32/(2*2*2);
    mu=64/(2*2*2);
    f1d=imresize(f1,[320/8,320/8]);
    f2d=imresize(f2,[320/8,320/8]);
    %bruteforce search on this level
    %movement vector calculations
    movement_vectors={};
    mv=1;
    for x=1:mu:size(f1d,1)
        for y=1:mu:size(f1d,1)
           up=x-ku;
            if(up<1)
                up=1;
            end
            down=x+64+ku;
            if(down>320/8)
                down=320/8-ku-1;
            end
            left=y-ku;
            if(left<1)
                left=1;
            end
            right=y+64+ku;
            if(right>320/8)
                right=320/8-ku-1;
            end
            %calculating movement vector of current level
            position=[x,y];
            mad=1000000000;
            for hor=left:right
                for ver=up:down
                   img1=f1d(hor:hor+ku-1,ver:ver+ku-1);
                   img2=f2d(x:x+ku-1,y:y+ku-1);
                   if(mad>mean_absolute_distance(img2,img1))
                       mad=mean_absolute_distance(img2,img1);
                       position=[hor,ver];
                   end
                end
            end
            movement_vectors{mv}=position;
            mv=mv+1;
        end
    end

    for i=5:-2:1
        for mv=1:length(movement_vectors)
            movement_vectors{mv}=movement_vectors{mv}*2;
        end
        if(i~=1)
            ku=32/(i-1);
            mu=64/(i-1);
            f1d=imresize(f1,[320/(i-1),320/(i-1)]);
            f2d=imresize(f2,[320/(i-1),320/(i-1)]);
        else
            ku=k;
            mu=m;
            f1d=f1;
            f2d=f2;
        end
        for mv=1:length(movement_vectors)
            centers={};
            cen=1;
            for ver=-ku:ku:ku
                for hor=-ku:ku:ku
                    if(movement_vectors{mv}(1)+ver>0 && movement_vectors{mv}(2)+hor>0 )
                        if(movement_vectors{mv}(1)+ver<size(f1d,1) && movement_vectors{mv}(2)+hor<size(f1d,1) )
                            centers{cen}=[movement_vectors{mv}(1)+ver-1,movement_vectors{mv}(2)+hor-1];
                            cen=cen+1;
                        end
                    end
                end
            end
            [xi,yi]=get_macroblock_position(mv,i-1);
            ximv=movement_vectors{mv}(1);
            if(ximv+mu>size(f1d,1))
                    ximv=size(f1d,1)-mu;
            end
            yimv=movement_vectors{mv}(2);
            if(yimv+mu>size(f1d,1))
                yimv=size(f1d,1)-mu;
            end
            mad=mean_absolute_distance(f2d(xi:xi+mu-1,yi:yi+mu-1),f1d(ximv:ximv+mu-1,yimv:yimv+mu-1));
            for cen=1:length(centers)
                ximv=centers{cen}(1);
                if(ximv+mu>size(f1d,1))
                    ximv=size(f1d,1)-mu;
                end
                yimv=centers{cen}(2);
                if(yimv+mu>size(f1d,1))
                    yimv=size(f1d,1)-mu;
                end
                mad_test=mean_absolute_distance(f2d(xi:xi+mu-1,yi:yi+mu-1),f1d(ximv:ximv+mu-1,yimv:yimv+mu-1));
                if(mad_test<mad)
                    mad=mad_test;
                    xi=ximv;
                    yi=yimv;
                end
            end
            movement_vectors{mv}=[xi,yi];
            
        end
       
    end
    frame=zeros([320,320]);
    mv=1;
    for i=1:64:320
        for j=1:64:320
            frame(i:i+63,j:j+63)=f1(movement_vectors{mv}(1):movement_vectors{mv}(1)+63,movement_vectors{mv}(2):movement_vectors{mv}(2)+63);
            mv=mv+1;
        end
    end


            

end

