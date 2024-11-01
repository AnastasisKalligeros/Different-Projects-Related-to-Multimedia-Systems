clc
clear

v=VideoReader('cars_passing_by.avi');
frames=read(v);

%reshaping and turning video to grayscale
gray_frames=zeros(320,320,size(frames,4));
for i=1:size(frames,4)
    gray_frames(:,:,i)=imresize(rgb2gray(frames(:,:,:,i)),[320,320]);
end

%choosing frame that has no objects
TARGET_FRAME=300;
%replacing each macroblock with movement with one of the previous
no_object_frames=zeros(size(gray_frames));
for f=1:size(gray_frames,3)
    for i=1:64:320
        for j=1:64:320
            if(mean_absolute_distance(gray_frames(i:i+63,j:j+63,f),gray_frames(i:i+63,j:j+63,TARGET_FRAME))>0)
                no_object_frames(i:i+63,j:j+63,f)=gray_frames(i:i+63,j:j+63,TARGET_FRAME);
            else
                no_object_frames(i:i+63,j:j+63,f)=gray_frames(i:i+63,j:j+63,f);
            end
        end
    end
end

no_object_frames=uint8(no_object_frames);

out=VideoWriter('question_2.avi');
open(out);
for i=1:size(no_object_frames,3)
    writeVideo(out,no_object_frames(:,:,i));
end
close(out);

