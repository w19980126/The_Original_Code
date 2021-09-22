%% 
% file文件是通过dir函数读入的各exptab.mat文件
function file = sortObj(file)
A = cell(size(file));
for i = 1:length(file)
    A{i} = file(i).name;
end
[~, ind] = natsortfiles(A);

for j = 1:length(file)
    files(j) = file(ind(j));
end
clear file;
file = files';