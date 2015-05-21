function [ InterpVals ] = TriNLinearInterp(inputMat, IndexSequence, samplingFactor)
%NLINEARINTERP Summary of this function goes here
%   Detailed explanation goes here


RowsAbove = floor((IndexSequence(1,:)-1)/samplingFactor);
RowsBelow = floor((IndexSequence(1,:)-1)/samplingFactor)+1;
ColsBefore = floor((IndexSequence(2,:)-1)/samplingFactor);
ColsAfter = floor((IndexSequence(2,:)-1)/samplingFactor)+1;
PageBefore = floor((IndexSequence(3,:)-1)/samplingFactor);
PageAfter = floor((IndexSequence(3,:)-1)/samplingFactor)+1;
% The above vectors give indices starting from 0

NeighborVals = zeros(8,size(IndexSequence,2));
lx = size(inputMat,2);
ly = size(inputMat,1);
lz = size(inputMat,3);

HaveColsAfter = ColsAfter < lx;
HaveRowsBelow = RowsBelow < ly;
HavePageAfter = PageAfter < lz;

NeighborVals(1,:) = inputMat(RowsAbove + ColsBefore*ly + PageBefore*lx*ly + 1);	%000
ValidInds = HaveRowsBelow;
NeighborVals(2, ValidInds) = ...
	inputMat(RowsBelow(ValidInds) + ColsBefore(ValidInds)*ly + PageBefore(ValidInds)*lx*ly + 1); %001

ValidInds = HaveColsAfter;
NeighborVals(2, ValidInds) = ...
	inputMat(RowsAbove(ValidInds) + ColsAfter(ValidInds)*ly + PageBefore(ValidInds)*lx*ly + 1); %010

ValidInds = HaveRowsBelow & HaveColsAfter;
NeighborVals(2, ValidInds) = ...
	inputMat(RowsBelow(ValidInds) + ColsAfter(ValidInds)*ly + PageBefore(ValidInds)*lx*ly + 1); %011

ValidInds = HavePageAfter;
NeighborVals(2, ValidInds) = ...
	inputMat(RowsAbove(ValidInds) + ColsBefore(ValidInds)*ly + PageAfter(ValidInds)*lx*ly + 1); %100

ValidInds = HavePageAfter & HaveRowsBelow;
NeighborVals(2, ValidInds) = ...
	inputMat(RowsBelow(ValidInds) + ColsBefore(ValidInds)*ly + PageAfter(ValidInds)*lx*ly + 1); %101

ValidInds = HavePageAfter & HaveColsAfter;
NeighborVals(2, ValidInds) = ...
	inputMat(RowsAbove(ValidInds) + ColsAfter(ValidInds)*ly + PageAfter(ValidInds)*lx*ly + 1); %110

ValidInds = HavePageAfter & HaveColsAfter & HaveRowsBelow;
NeighborVals(2, ValidInds) = ...
	inputMat(RowsBelow(ValidInds) + ColsAfter(ValidInds)*ly + PageAfter(ValidInds)*lx*ly + 1); %111

% 0xx
NeighborVals(1:4, :) = bsxfun(@times, NeighborVals(1:4, :), (samplingFactor - mod(IndexSequence(3,:), samplingFactor))/samplingFactor);

% 1xx
NeighborVals(4:8, :) = bsxfun(@times, NeighborVals(4:8, :), mod(IndexSequence(3,:), samplingFactor)/samplingFactor);

% x0x
NeighborVals([0,1,4,5]+1, :) = bsxfun(@times, NeighborVals([0,1,4,5]+1, :), (samplingFactor - mod(IndexSequence(3,:), samplingFactor))/samplingFactor);

% x1x
NeighborVals([2,3,6,7]+1, :) = bsxfun(@times, NeighborVals([2,3,6,7]+1, :), mod(IndexSequence(2,:), samplingFactor)/samplingFactor);

% xx0
NeighborVals(1:2:8, :) = bsxfun(@times, NeighborVals(1:2:8, :), (samplingFactor - mod(IndexSequence(3,:), samplingFactor))/samplingFactor);

% xx1
NeighborVals(2:2:8, :) = bsxfun(@times, NeighborVals(2:2:8, :), mod(IndexSequence(2,:), samplingFactor)/samplingFactor);

InterpVals = sum(NeighborVals);
end

