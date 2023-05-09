function mark_parameters_AD_curve(tauB,B,tauN,N,tauK,K,tau,lineB,lineK,lineN)
    if ~isnan(tauB)
        loglog(tauB,0.664*B,'o','LineWidth',3)
    end
    
    hold on
    if ~isnan(tauN)
        loglog(tauN,N,'o','LineWidth',3)
    end
    
    hold on
    if ~isnan(tauK)
        loglog(tauK,K,'o','LineWidth',3)
    end
    
    hold on
    if ~isnan(lineB)
        loglog(tau,lineB,'--k')
    end
    
    hold on
    if ~isnan(lineK)
        loglog(tau,lineK,'--k')
    end
    
    hold on
    if ~isnan(lineN)
        loglog(tau,lineN,'--k')
    end
    
    if ~isnan(tauN) || ~isnan(tauK) || ~isnan(tauB)
        text([tauN-0.4 tauK+1 tauB], [N-0.000005 K 0.664*B-0.000003],...
        {'N', 'K', '0.664B'}, 'FontWeight','bold','FontSize',14)
    end
end
