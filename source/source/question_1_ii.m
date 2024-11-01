clc
clear

v=VideoReader('cars_passing_by.avi');
frames=read(v);

%reshaping and turning video to grayscale
gray_frames=zeros(320,320,size(frames,4));
for i=1:size(frames,4)
    gray_frames(:,:,i)=imresize(rgb2gray(frames(:,:,:,i)),[320,320]);
end

%ENCODING
%hierarchical search
encoded=zeros(320,320,size(frames,4)-1);
for i=1:size(frames,4)-1
    encoded(:,:,i)=search(gray_frames(:,:,i+1),gray_frames(:,:,i));
end



errors=zeros(size(encoded));
for i=1:size(errors,3)
    %the first encoded frame is the second gray frame
    errors(:,:,i)=encoded(:,:,i)-gray_frames(:,:,i+1);
end

%DECODING
decoded=zeros(size(encoded));
for i=1:size(encoded,3)
    decoded(:,:,i)=encoded(:,:,i)-errors(:,:,i);
end

decoded=uint8(decoded);

%saving decoded video
out=VideoWriter('question_1_ii.avi');
open(out);
for i=1:size(decoded,3)
    writeVideo(out,decoded(:,:,i));
end
close(out);


