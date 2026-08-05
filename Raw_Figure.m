%%
%% cfg 

data.cfg.info.n_sbj='26';
data.cfg.info.i_chan=[1 2 3 4 5 6];
data.cfg.info.dx='pd';
data.cfg.info.Fs=1000;
data.cfg.trial_data.t1.filename = path + "/pro00073545_0026/ecog/VRP_26-210223-160648"
% freq bands
frq_band_txt{1}='delta';
frq_band_txt{2}='theta';
frq_band_txt{3}='alpha';
frq_band_txt{4}='beta';
frq_band_txt{5}='gamma';
frq_band_txt{6}='gamma_l';
frq_band_txt{7}='gamma_bb';

frq_band_ind{1}=['2:3'];
frq_band_ind{2}=['3:5'];
frq_band_ind{3}=['5:7'];
frq_band_ind{4}=['8:16'];
frq_band_ind{5}=['16:206'];
frq_band_ind{6}=['16:27'];
frq_band_ind{7}=['28:103'];


% filters
[n2_b, n2_a]=butter(3,2*[117 123]/data.cfg.info.Fs,'stop');%120 Hz
[n3_b, n3_a]=butter(3,2*[177 183]/data.cfg.info.Fs,'stop');%180 Hz

% parse trials
names_trial_num=regexp(fieldnames(data.cfg.trial_data),'[0-9]','match');
for i=1:size(names_trial_num,1)
    n_trial(i)=str2double(names_trial_num{i});
end

% resample and filter signals
% for i=1:size(n_trial,2)
%     eval(['temp.t',num2str(i)','.sig.all=TDTbin2mat(data.cfg.trial_data.t',num2str(i),'.filename);'])
%     eval(['temp.t',num2str(i),'.sig.trig=resample(double(temp.t',num2str(i),'.sig.all.streams.Trig.data)'',2^10,5^5);'])
%     eval(['temp.t',num2str(i),'.sig.ecog=filtfilt(n3_b,n3_a,filtfilt(n2_b,n2_a,resample(double(temp.t',num2str(i),'.sig.all.streams.ECOG.data)'',2^10,5^5)));'])
%     eval(['temp.t',num2str(i),'.sig.amps=resample(double(temp.t',num2str(i),'.sig.all.streams.amps.data)'',2^10,5^5);'])
%     eval(['temp.t',num2str(i),'.sig.sync=resample(double(temp.t',num2str(i),'.sig.all.streams.Sync.data)'',2^10,5^5);'])
% end

for i=1:size(n_trial,2)
    eval(['temp.t',num2str(i)','.sig.all=TDTbin2mat(char(data.cfg.trial_data.t',num2str(i),'.filename));'])
    eval(['temp.t',num2str(i),'.sig.trig=resample(double(temp.t',num2str(i),'.sig.all.streams.Trig.data)'',2^10,5^5);'])
    eval(['temp.t',num2str(i),'.sig.ecog=filtfilt(n3_b,n3_a,filtfilt(n2_b,n2_a,resample(double(temp.t',num2str(i),'.sig.all.streams.ECOG.data)'',2^10,5^5)));'])
    eval(['temp.t',num2str(i),'.sig.amps=resample(double(temp.t',num2str(i),'.sig.all.streams.amps.data)'',2^10,5^5);'])
    eval(['temp.t',num2str(i),'.sig.sync=resample(double(temp.t',num2str(i),'.sig.all.streams.Sync.data)'',2^10,5^5);'])
    %eval(['temp.t',num2str(i),'.sig.beta=resample(double(temp.t',num2str(i),'.sig.all.streams.Beta.data)'',2^10,5^5);'])
    %eval(['temp.t',num2str(i),'.sig.gamma=resample(double(temp.t',num2str(i),'.sig.all.streams.Gamm.data)'',2^10,5^5);'])

end

figure;% plot(temp.t1.sig.beta)
set(gca,'ylim',[-6e-11 6e-10])
%hold on; plot(temp.t1.sig.gamma*1e2)
hold on; plot(temp.t1.sig.ecog(:,1)/1e7)
plot(temp.t1.sig.ecog(:,2)/1e7+1e-10)
plot(temp.t1.sig.ecog(:,3)/1e7+2e-10)
plot(temp.t1.sig.ecog(:,4)/1e7+3e-10)
plot(temp.t1.sig.ecog(:,5)/1e7+4e-10)
plot(temp.t1.sig.ecog(:,6)/1e7+5e-10)



for i=1:size(n_trial,2)
    eval(['data.trials.t',num2str(i),'.sig.trig=temp.t',num2str(i),'.sig.trig'])
    eval(['data.trials.t',num2str(i),'.sig.ecog=temp.t',num2str(i),'.sig.ecog'])
    eval(['data.trials.t',num2str(i),'.sig.amps=temp.t',num2str(i),'.sig.amps'])
    eval(['data.trials.t',num2str(i),'.sig.sync=temp.t',num2str(i),'.sig.sync'])
end

%calculate psd of whole epoch
for i=1:size(mat_trial_epoch,1)
    for j=1:mat_trial_epoch(i,3)

        eval(['[data.trials.t',num2str(i),'.psd.e',num2str(j),'.sawRAW,data.trials.t',num2str(i),'.psd.freq]=pwelch(data.trials.t',num2str(i),...
            '.sig.ecog([data.trials.t',num2str(i),'.epochs.e',num2str(j),'(1):data.trials.t',num2str(i),'.epochs.e',num2str(j),'(2)],:),512,[],1024,1000);']);
    end
end
data.cfg.trial_data.t1.cond='multi';

for i=1:size(mat_trial_epoch,1)
    for j=1:mat_trial_epoch(i,3)
        for k=1:eval(['(data.trials.t',num2str(i),'.epochs.e',num2str(j),'(2)-data.trials.t',...
                num2str(i),'.epochs.e',num2str(j),'(1))/1000'])
            eval(['data.trials.t',num2str(i),'.psd.e',num2str(j),'.sai.vals(',num2str(k),',:,:)=pwelch(data.trials.t',...
                num2str(i),'.sig.ecog([(',num2str(k),'-1)*1000+1+data.trials.t',num2str(i),'.epochs.e',num2str(j),...
                '(1):',num2str(k),'*1000+data.trials.t',num2str(i),'.epochs.e',num2str(j),'(1)],:),512,256,512,1000);']);
        end
    end
end



%calculate psd of whole epoch
for i=1:size(mat_trial_epoch,1)
    for j=1:mat_trial_epoch(i,3)

        eval(['[data.trials.t',num2str(i),'.psd.e',num2str(j),'.saw,data.trials.t',num2str(i),'.psd.freq]=pwelch(data.trials.t',num2str(i),...
            '.sig.ecogCAR([data.trials.t',num2str(i),'.epochs.e',num2str(j),'(1):data.trials.t',num2str(i),'.epochs.e',num2str(j),'(2)],:),512,[],1024,1000);']);
    end
end
data.cfg.trial_data.t1.cond='multi';
%plot psd curves - separate by epoch - all channels overlaid
for i=1:size(mat_trial_epoch,1)
    for j=1:mat_trial_epoch(i,3)

        %if j==1
        figure
        hold on
        %set(gcf,'Position',[100 10 560 740])
        %end
        %subplot(2,2,j)
        eval(['plot(data.trials.t',num2str(i),'.psd.freq(1:206),log10(data.trials.t',num2str(i),'.psd.e',num2str(j),'.saw(1:206,:)))'])
        ylabel('log power')
        xlabel('Hz')
        %if j==1
        legend('Lch1','Lch2','Lch3','Lch4','Lch5','Lch6')
        title(['s',data.cfg.info.n_sbj,' t',num2str(i),' ',eval(['data.cfg.trial_data.t',num2str(i),'.cond']),' e',num2str(j),' all channels'])


        %end
    end
end

for i=1:size(mat_trial_epoch,1)
    for j=1:mat_trial_epoch(i,3)
        for k=1:eval(['(data.trials.t',num2str(i),'.epochs.e',num2str(j),'(2)-data.trials.t',...
                num2str(i),'.epochs.e',num2str(j),'(1))/1000'])
            eval(['data.trials.t',num2str(i),'.psd.e',num2str(j),'.sai.vals(',num2str(k),',:,:)=pwelch(data.trials.t',...
                num2str(i),'.sig.ecogCAR([(',num2str(k),'-1)*1000+1+data.trials.t',num2str(i),'.epochs.e',num2str(j),...
                '(1):',num2str(k),'*1000+data.trials.t',num2str(i),'.epochs.e',num2str(j),'(1)],:),512,256,512,1000);']);
        end
    end
end


%% ---------- CAR first ----------
mean_signal = mean(data.trials.t1.sig.ecog(:,1:6),2);
data.trials.t1.sig.ecogCAR = data.trials.t1.sig.ecog(:,1:6) - mean_signal;

pdfout    = "Raw_Data_Figure.pdf";
if exist(pdfout,'file'), delete(pdfout); end

sigfields = {'ecog','ecogCAR'};
psdfields = {'sawRAW','saw'};
sigtitles = {'RAW','CAR'};
pos_nm    = {'pre','RA','LA','post'};
inverted_chan = 6:-1:1;

data.trials.t1.epochs.e1(1,1)=1.03e5; %No stim Pre Move
data.trials.t1.epochs.e1(1,2)=1.29e5;
data.trials.t1.epochs.e2(1,1)=1.63e5; %No stim RA Flex
data.trials.t1.epochs.e2(1,2)=1.90e5;
data.trials.t1.epochs.e3(1,1)=1.90e5; %No stim LA Flex
data.trials.t1.epochs.e3(1,2)=2.17e5;
data.trials.t1.epochs.e4(1,1)=2.17e5; %No stim Post Move
data.trials.t1.epochs.e4(1,2)=2.37e5;
data.trials.t1.epochs.e5(1,1)=3.00e5; %2.0 Anodal Pre Move
data.trials.t1.epochs.e5(1,2)=3.40e5;
data.trials.t1.epochs.e6(1,1)=3.40e5; %2.0 Anodal RA Flex
data.trials.t1.epochs.e6(1,2)=3.64e5;
data.trials.t1.epochs.e7(1,1)=3.64e5; %2.0 mA Anodal LA Flex
data.trials.t1.epochs.e7(1,2)=3.88e5;
data.trials.t1.epochs.e8(1,1)=3.88e5; %2.0 mA Anodal Post Move
data.trials.t1.epochs.e8(1,2)=4.08e5;
data.trials.t1.epochs.e9(1,1)=4.56e5; %No stim (rest 2) Pre Move
data.trials.t1.epochs.e9(1,2)=4.96e5;
data.trials.t1.epochs.e10(1,1)=4.96e5; %No stim (rest 2) RA Flex
data.trials.t1.epochs.e10(1,2)=5.15e5;
data.trials.t1.epochs.e11(1,1)=5.15e5; %No stim (rest 2) LA Flex
data.trials.t1.epochs.e11(1,2)=5.34e5;
data.trials.t1.epochs.e12(1,1)=5.34e5; %No stim (rest 2) Post Move
data.trials.t1.epochs.e12(1,2)=5.54e5;

%% ---------- CAR ----------
mean_signal = mean(data.trials.t1.sig.ecog(:,1:6),2);
data.trials.t1.sig.ecogCAR = data.trials.t1.sig.ecog(:,1:6) - mean_signal;

pdfout    = "Raw_Data_Figure.pdf";
if exist(pdfout,'file'), delete(pdfout); end
sigfields = {'ecog','ecogCAR'};
psdfields = {'sawRAW','saw'};
sigtitles = {'RAW','CAR'};
pos_nm    = {'pre','RA','LA','post'};
inverted_chan = 6:-1:1;

% ===== SIZE KNOBS =====
psd_h   = 0.030;    % <-- height of each PSD panel (was effectively ~0.07)
psd_w   = 0.30;     % <-- width of each PSD panel
psd_gap = 0.004;
psd_top = 0.30;     % PSD block top edge

fh = figure('Position',[20 10 1100 1600],'Color','w');

ts_y = [0.83 0.68];
for s = 1:2
    axes('Position',[0.08 ts_y(s) 0.86 0.12]); hold on
    n = size(data.trials.t1.sig.(sigfields{s}),1);
    t = (1:n)/1000;                                    % <-- ADDED: seconds
    for j = 1:6
        plot(t, data.trials.t1.sig.(sigfields{s})(:,j)*10 + j*1e-2);   % <-- t
    end
    plot(t, data.trials.t1.sig.trig(:,1));             % <-- t
    plot(t, data.trials.t1.sig.amps(:,1)/100);         % <-- t
    for k = 1:12
        ep = data.trials.t1.epochs.(['e' num2str(k)])/1000;   % <-- /1000
        plot([ep(1) ep(1)],[-0.01 0.08],'g');
        plot([ep(2) ep(2)],[-0.01 0.08],'r');
        text(mean(ep), 0.078, sprintf('e%d %s',k,pos_nm{mod(k-1,4)+1}), ...
             'HorizontalAlignment','center','VerticalAlignment','top', ...
             'FontSize',5,'Rotation',90);
    end
    ylim([-0.01 0.08]); xlim([0 600]);                 % <-- 600 s, was 6.0e5
    ylabel(sigtitles{s},'FontWeight','bold');
    xlabel('Time (s)','FontSize',8);
    
    %if s==1, title('Time series with epochs','FontSize',10); end
    hold off
end

% ---------- spectrograms: side by side ----------
for s = 1:2
    [S,F,T] = spectrogram(data.trials.t1.sig.(sigfields{s})(:,4),512,[],1024,1000);
    P = 10*log10(abs(S).^2 + eps);
    axes('Position',[0.08+(s-1)*0.47 0.44 0.38 0.16]); hold on
    imagesc(T,F,P); axis xy; colormap(gca,jet); clim([-100 -40]);
    ylim([0 200]); xlim([0 600]);
    xlabel('Time (s)','FontSize',7); ylabel('Hz','FontSize',7);
    title(sprintf('%s spectrogram (ch4)',sigtitles{s}),'FontSize',9);
    for k = 1:12
        e = data.trials.t1.epochs.(['e' num2str(k)]);
        plot([e(1) e(1)]/1000,[0 200],'w-','LineWidth',0.6);
        plot([e(2) e(2)]/1000,[0 200],'w:','LineWidth',0.6);
        text(e(1)/1000, 190, sprintf('e%d',k),'Color','w','FontSize',5, ...
             'Rotation',90,'HorizontalAlignment','right');
    end
    hold off
end

% ---------- PSDs: small, no ticks, bold axes ----------
for s = 1:2
    for k = 1:6
        x = 0.12 + (s-1)*(psd_w + 0.10);
        y = psd_top - (k-1)*(psd_h + psd_gap) - psd_h;
        axes('Position',[x y psd_w psd_h]); hold on
        for j = 1:12
            plot(data.trials.t1.psd.freq(1:206), ...
                 log10(data.trials.t1.psd.(['e' num2str(j)]).(psdfields{s})(1:206, inverted_chan(k))), ...
                 'LineWidth',0.5);
        end
        xlim([0 200]);
        set(gca,'XTick',[],'YTick',[]);
        ylabel(sprintf('ch%d',inverted_chan(k)),'FontSize',6);
        if k==1, title(sprintf('%s PSD',sigtitles{s}),'FontSize',9); end
        hold off
    end
end

%sgtitle(sprintf('Subject %s — raw vs CAR overview', data.cfg.info.n_sbj),'FontSize',13);


%% ---------- export as VECTOR for Inkscape ----------
exportgraphics(fh, pdfout, 'ContentType','vector', 'Resolution', 2000);