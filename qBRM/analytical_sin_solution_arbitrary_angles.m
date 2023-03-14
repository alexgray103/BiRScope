function solve_qBRM_symbolic = analytical_sin_solution_arbitrary_angles(angles)

    % matlab function to solve sinusoid with three points 
%{


    %%%%%%%%%%%%%%%%%%%%%%%%   Equation:  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %              I(Θ) = (Io/2)*(1-sin(2Θ-2Φ)sin(δ))                 %
    %                                                                 %
    %     given three intensities at three different Pol. angles Θ    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % use matlab symbolic variables to solve for analytical solution to
    % sinusoid with three arbitrary points 
    % I1 = intensity at point 1
    % I2 = intensity at point 2
    % I3 = intensity at point 3

    % Phi = orientation value
    % A = retardance (already normalized)
    % Io = mean value of sinusoid

    %%%%%%%%%%%%%%%%%%% 
    %%% example code after creating this function:
    angles = [0 60 120];
    solve_qBRM_symbolic = analytical_sin_solution_arbitrary_angles(angles);
    
    % load image of different polarizer angles
    img(:,:,1) = load('img_0deg.mat')
    img(:,:,2) = load('img_60deg.mat')
    img(:,:,3) = load('img_120deg.mat')
    
    [A, Io, Phi] = solve_qBRM_symbolic(img(:,:,1),img(:,:,2),img(:,:,3));
    phi = real(phi);
    A = abs(real(A));
    C = real(C);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %}
    if length(angles) ~= 3
        error('Input angles must be length of 3')
    end

    angles =sort(angles, 'ascend');
    syms A Io phi I1 I2 I3
    eq1 = -I1 + Io/2 + A*sin(2*(angles(1)-phi))*Io/2 == 0;
    eq2 = -I2 + Io/2 + A*sin(2*((angles(2)*pi/180)-phi))*Io/2 == 0;
    eq3 = -I3 + Io/2 + A*sin(2*((angles(3)*pi/180)-phi))*Io/2 == 0;
    eqs = [eq1 eq2 eq3];
    vars = [phi, A,Io];
    sol_basic = solve(eqs,vars);

    % right now it only selects the first solution (not sure if we should
    % check which solution is better
    solve_qBRM_symbolic = matlabFunction(sol_basic.A(1,1), sol_basic.Io(1,1), sol_basic.phi(1,1));
    % solve_qBRM is a function handle that takes inputs of [I1 I2 I3]

end