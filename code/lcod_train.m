function network = lcod_train( X, Wd, Zstar, alpha, T, conv_thres, conv_count_thres )
%TRAIN Summary of this function goes here
% X: training input signal nxm (m input of size n)
% W: dictionary nxk (k basis vector size n)
% Zstar: kxm (m sparse code with coeffs size k)
% alpha: sparse penalty
% T: depth of the neural network
% P: number of training iteration
% Training use Back-propagation through time
% Ask Ms. Homa about the alpha value
  %initialize variables
  disp(strcat({'Alpha is '}, num2str(alpha)));
  disp(strcat({'Network depth is '}, num2str(T)));
  disp(strcat({'Convergence threshold is '}, num2str(conv_thres)));
  We=Wd';
  L=max(eig(Wd'*Wd))+1;
  S=eye(size(Wd'*Wd))-1/L*(Wd'*Wd);
  P=size(X,2);
  theta=alpha*ones(size(Zstar,1),1);
  %for j=1:num_iter
  dWe=Inf; dS=Inf; dtheta=Inf;
  j=0;
  conv_count=0;
  while true
    j=j+1;
    idx=mod(j-1,P)+1;
    conv_coef=1/j;
    if any(conv_coef*[max(abs(dWe(:))); max(abs(dS(:))); max(abs(dtheta(:)))]>=conv_thres)
      conv_count=0;
    else
      conv_count=conv_count+1;
    end
    if (conv_count==conv_count_thres)
      break;
    end
    disp(strcat({'Iteration '},num2str(j)));
    [Z,K,b,e,B]=lcod_fprop(X(:,idx),We,S,theta,T);
    [dWe,dS,dtheta,dX]=lcod_bprop(X(:,idx),Zstar(:,idx),Z,We,S,theta,e,K,b,B,T);
    if all(dWe(:)==0)||all(dS(:)==0)||all(dtheta(:)==0)
      1;
    end;
    We=We-conv_coef*dWe; We=col_norm(We',2)';
    S=S-conv_coef*dS;
    theta=theta-conv_coef*dtheta;
    max(abs(conv_coef*dWe(:)))
    max(abs(conv_coef*dS(:)))
    max(abs(conv_coef*dtheta(:)))
  end
  network.We=We;
  network.S=S;
  network.theta=theta;
  network.alpha=alpha;
  network.T=T;
  network.conv_thres=conv_thres;
  disp('Finished');
end