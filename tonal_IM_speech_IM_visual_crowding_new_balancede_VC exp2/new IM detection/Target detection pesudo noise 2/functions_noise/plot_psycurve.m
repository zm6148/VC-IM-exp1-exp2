function plot_psycurve( ax, psy_para_multi )

% select unique octave separation

octave_separation = unique(psy_para_multi(:, 5));
color = ['b','g','r','y'];

axes(ax);
for ii = 1: length(octave_separation)
    
    % matrix of all of the same separation
    t_m_separation = octave_separation(ii);
    para_at_t_m_separation_index = psy_para_multi(:,5) ==  t_m_separation;
    para_at_t_m_separation = psy_para_multi(para_at_t_m_separation_index, :);
    
    % plot
    x=unique(para_at_t_m_separation(:,6)); % each t m loudness difference
    y=[]; % accurace at that point
    % disp(x);
    
    for jj=1:length(x)
        y(jj)=(sum(para_at_t_m_separation(:,6)==x(jj) & para_at_t_m_separation(:,7)== para_at_t_m_separation(:,13)))/(sum(para_at_t_m_separation(:,6)==x(jj)));
    end
    
    hold on;
    plot(x,y*100,['-', color(ii)],...
        'LineWidth',2,...
        'MarkerSize',10,...
        'MarkerEdgeColor','b',...
        'MarkerFaceColor',[0.5,0.5,0.5])
    axis([min(x) max(x) 0 100])
    set(gca,'XTick',x);
    xlabel('Targer Mask loudness difference in dB');
    ylabel('Percentage of Correctness');
    
    
    % calculate unique target mask loundness difference accurace and plot
    % against mask loundness difference
end
legend('0.3 octave separation', '0.5 octave separation', '1 octave separation', '2 octave separation');

end

