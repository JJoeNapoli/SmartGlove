% This function checks whether or not passed parameter is a hand

function ish = SGisHand(hand)

ish = (isfield(hand,'F') && isfield(hand,'n') && ...
    isfield(hand,'q') && isfield(hand,'m') && ...
    isfield(hand,'n') && isfield(hand,'qin') && ...
    isfield(hand,'qinf') && isfield(hand,'ctype') && ...
    isfield(hand,'ftips') && isfield(hand,'S') && ...
    isfield(hand,'cp') && isfield(hand,'H') && ...
    isfield(hand,'Kq') && isfield(hand,'Kz') && ...
    isfield(hand,'J') && isfield(hand,'JS'));

end