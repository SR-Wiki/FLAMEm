function [ius_svd,RFsvd] = batchSVD3(ius_rec,cutoff1,cutoff2)
fprintf('Clutter filtering ... \n');
tcluter = tic;
[row,col,page,ensemble] = size(ius_rec);
S = reshape(ius_rec,[row*col*page,ensemble]);

    % eig value
    Covariance = S'*S;
    [U,~] = eig(Covariance);
    U = fliplr(U);
    V = S*U;
    RFsvdcasorati = V(:,cutoff1:cutoff2)*U(:,cutoff1:cutoff2)';
    RFsvd = reshape(RFsvdcasorati,[row, col, page, ensemble]);
    ius_svd = single(mean(abs(RFsvd),4));
toc(tcluter)
end