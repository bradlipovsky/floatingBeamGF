function plot_fit_wave(t,eventAlign,sigma,L_fit,M_frac_fit,G_fit,xFit,numIt,xStep,accept,p)

% plot resulting waveform and starting waveform
plot(t,G_fit);
hold on;
plot(t,eventAlign);
title("Data and Best-Fit Waveform")
xlabel("Time (s)")
ylabel("Normalized Velocity")
[k,mk] = max(G_fit);            
text(mk*4/3,k/1.5,string("Best-fit parameters" + newline + "----------------------------" + ...
                        newline + "h_i: " + xFit(1) + " m     h_w: " ...
                        + xFit(2) + " m" + newline + "X_{stat}: " + ...
                        xFit(3)/1000 + " km" + "     t_0: " + xFit(4) + ...
                        newline + "M/M_0: " + M_frac_fit + newline))
text(mk*4/3,k/3,string("MCMC parameters" + newline + "----------------------------" + newline + ...                            
                       "h_i step: " + xStep(1) + " m    h_w step: " + xStep(2) + " m" + newline + ...
                       "X_{stat} step: " + xStep(3) + " m    t_0 step: " + xStep(4) + " s" + newline + ...
                       "Number of iterations: " + numIt + newline + "Sigma: " + sigma + newline + ...
                       "L: " + L_fit + newline + "Accepted " + round(100*sum(accept)/length(accept)) + "% of proposals"))                   
l = legend("MCMC best-fit model","Data");
set(l,'Location','southwest');
set(gcf,'Position',[10 10 1000 800])
hold off
saveas(gcf,"/home/setholinger/Documents/Projects/PIG/modeling/mcmc/run" + p + "_fit_wave.png")
close(gcf)

end