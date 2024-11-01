clc
clear
v=VideoReader('cars_passing_by.avi');
frames=read(v);
gray_frames=zeros(size(frames,1),size(frames,2),size(frames,4));
%converting video to grayscale
for i=1:size(frames,4)
    gray_frames(:,:,i)=rgb2gray(frames(:,:,:,i));
end
error_frames=zeros(size(frames,1),size(frames,2),size(frames,4)-1);
for i=1:size(frames,4)-1
    error_frames(:,:,i)=gray_frames(:,:,i+1)-gray_frames(:,:,i);
end

error_frames=uint8(error_frames);

writer=VideoWriter('question_1_i.avi');
open(writer);
for i=1:size(error_frames,3)
    writeVideo(writer,error_frames(:,:,i));
end
close(writer);