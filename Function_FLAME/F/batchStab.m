function volume_stab = batchStab(volume0)
fprintf('Stablizing ...\n')
tstab = tic;
volume1 = squeeze(max(abs(volume0),[],3));
ensemble = size(volume1,3);
volumeref = mean(volume1,3);
nxcorrall = zeros(ensemble,1);
for iensemble = 1:ensemble
    xcorrtemp = normxcorr2(volumeref,volume1(:,:,iensemble));
    [nxcorrall(iensemble),~] = max(xcorrtemp(:));
end
nxcorrallavg = min(mean(nxcorrall),0.98);
figure(1),subplot(2,1,1),plot(nxcorrall),pbaspect([2 1 1]),title('2D nxcorr'),drawnow
volume_stab = volume0(:,:,:,nxcorrall>nxcorrallavg);
toc(tstab)
fprintf(['Avg. nxcorr: ',num2str(nxcorrallavg),', post-stab frame #: ',num2str(size(volume_stab,4)),'\n'])
end