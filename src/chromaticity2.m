function [X,Y] = chromaticity2(R, G, B)
    TT = R .* G .* B;
    TT = nthroot(TT, 3);
    R = R ./ TT;
    G = G ./ TT;
    B = B ./ TT;
    s = size(R,1) * size(R,2);
    RR = reshape(R, 1, s);
    GG = reshape(G, 1, s);
    BB = reshape(B, 1, s);
    RR = arrayfun(@(x) log(x), RR);
    GG = arrayfun(@(x) log(x), GG);
    BB = arrayfun(@(x) log(x), BB);
    v1 = [1/sqrt(2); -1/sqrt(2); 0]';
    v2 = [1/sqrt(6); 1/sqrt(6); -2/sqrt(6)]';
    U = [v1; v2];
    O = [RR; GG; BB];
    res = double(zeros(2,s));
    for i = 1:s
        res(:,i) = U * O(:,i);
    end;

    X = res(1,:);
    Y = res(2,:);
end