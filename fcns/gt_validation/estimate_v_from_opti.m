function [v_x, v_y, v_z] = estimate_v_from_opti(DataForYPR_deadreckoning, ind_of_interest)

    t2 = DataForYPR_deadreckoning.gt.time(ind_of_interest);
    t1 = DataForYPR_deadreckoning.gt.time(ind_of_interest-1);
    
    t = DataForYPR_deadreckoning.gt.time;
    
    p = 0.5;
    
    p_x = csaps(t,DataForYPR_deadreckoning.gt.position_w(:,1),p);
    p_y = csaps(t,DataForYPR_deadreckoning.gt.position_w(:,2),p);
    p_z = csaps(t,DataForYPR_deadreckoning.gt.position_w(:,3),p);
    
    p_x12 = fnval(p_x,[t1, t2]);
    p_y12 = fnval(p_y,[t1, t2]);
    p_z12 = fnval(p_z,[t1, t2]);
    
    v_x = (p_x12(1) - p_x12(2)) / (t1-t2);
    v_y = (p_y12(1) - p_y12(2)) / (t1-t2);
    v_z = (p_z12(1) - p_z12(2)) / (t1-t2);
  
%     figure(1)
%     fnplt(p_x,2)
%     hold on
%     plot(t,DataForYPR_deadreckoning.gt.position_w(:,1))
%     hold off
%     
%     figure(2)
%     fnplt(p_y,2)
%     hold on
%     plot(t,DataForYPR_deadreckoning.gt.position_w(:,2))
%     hold off
%     
%     figure(3)
%     fnplt(p_z,2)
%     hold on
%     plot(t,DataForYPR_deadreckoning.gt.position_w(:,3))
%     hold off

end

