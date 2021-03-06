(* ::Package:: *)

(* AddNewPeriodToSolvedLifeDatesPesReaOpt *)
ClearAll[AddNewPeriodToSolvedLifeDatesPesReaOpt];

AddNewPeriodToSolvedLifeDatesPesReaOpt := Block[{},
(* Use insight that Pesmst < Realst < Optmst for c and v *)
  \[FilledUpTriangle]\[GothicH]t     =  Last[\[FilledUpTriangle]\[GothicH]AccessibleLife];(* Amount by which expected exceeds minimum human wealth *)
  \[Kappa]t      = Last[\[Kappa]MinLife];  (* MPC for unconstrained perfect foresight consumer *)

  cVectOptmst = \[Kappa]t (\[FilledUpTriangle]mVect+\[FilledUpTriangle]\[GothicH]t); (* Optimist *)
  cVectRealst = cVect;           (* Realist's solution already obtained in AddNewPeriodToSolvedLifeDates  *)
  cVectPesmst = \[Kappa]t  \[FilledUpTriangle]mVect;      (* Pessimist *)

  \[Kappa]VectOptmst = \[Kappa]t;
  \[Kappa]VectRealst = \[Kappa]Vect;
  \[Kappa]VectPesmst = \[Kappa]t;

  \[Koppa]Vals  = (cVectOptmst-cVectRealst)/(cVectOptmst-cVectPesmst);
  \[Koppa]\[Mu]Vals = \[FilledUpTriangle]mVect (\[Kappa]VectOptmst - \[Kappa]VectRealst)/(\[Kappa]t \[FilledUpTriangle]\[GothicH]t);

  \[Chi]Vals  = Log[(1/\[Koppa]Vals)-1];
  \[Chi]\[Mu]Vals = \[Koppa]\[Mu]Vals/((\[Koppa]Vals-1) \[Koppa]Vals);  (* Derivative of \[Chi] wrt \[Mu] *)

(* Aug represents Augumented, as opposed to the raw grid. *)
(* The first and the last elements are added for linear interpolation. *)
  \[Mu]VectAug=Join[{\[Mu]Vect[[1]]-\[Mu]SmallGapLeft}
, \[Mu]Vect
, {\[Mu]Vect[[-1]]+\[Mu]SmallGapRight}
];
  \[Koppa]ValsAug=Join[{\[Koppa]Vals[[1]]-\[Koppa]\[Mu]Vals[[1]]*\[Mu]SmallGapLeft}
, \[Koppa]Vals
, {\[Koppa]Vals[[-1]]+\[Koppa]\[Mu]Vals[[-1]]*\[Mu]SmallGapRight}
];
  \[Koppa]\[Mu]ValsAug=Join[{\[Koppa]\[Mu]Vals[[1]]}
, \[Koppa]\[Mu]Vals
, {\[Koppa]\[Mu]Vals[[-1]]}
];
  \[Chi]ValsAug=Join[{\[Chi]Vals[[1]]-\[Chi]\[Mu]Vals[[1]]*\[Mu]SmallGapLeft}
, \[Chi]Vals
, {\[Chi]Vals[[-1]]+\[Chi]\[Mu]Vals[[-1]]*\[Mu]SmallGapRight}
];
  \[Chi]\[Mu]ValsAug=Join[{\[Chi]\[Mu]Vals[[1]]}
, \[Chi]\[Mu]Vals
, {\[Chi]\[Mu]Vals[[-1]]}
];

  \[Koppa]Data=Transpose[{AddBracesTo[\[Mu]VectAug],\[Koppa]ValsAug,\[Koppa]\[Mu]ValsAug}];
  \[Chi]Data=Transpose[{AddBracesTo[\[Mu]VectAug],\[Chi]ValsAug,\[Chi]\[Mu]ValsAug}];

  AppendTo[\[Koppa]FuncLife, Interpolation[\[Koppa]Data]];
 (* This is a clever way to avoid the mannual linear extrapolation below the first and above the last grid points. *)
  \[Chi]Func=Interpolation[\[Chi]Data];
  AppendTo[\[Chi]FuncLife, \[Chi]Func];


  vmVect = uP[cVect];
  \[CapitalLambda]Vect = ((1-\[Rho])vVect)^(1/(1-\[Rho]));
  \[CapitalLambda]mVect = ((1-\[Rho])vVect)^(-1+1/(1-\[Rho]))*vmVect; 
 (* Using Envelope relation uP[c]=vm[m] *)

  vVectRealst=vVect;
  vSumt=Last[vSumLife];

  \[CapitalLambda]VectOptmst = cVectOptmst (vSumt)^(1/(1-\[Rho]));
  \[CapitalLambda]VectRealst = \[CapitalLambda]Vect;
  \[CapitalLambda]VectPesmst = cVectPesmst (vSumt)^(1/(1-\[Rho]));

  \[CapitalLambda]mVectOptmst = \[Kappa]t (vSumt)^(1/(1-\[Rho]));
  \[CapitalLambda]mVectRealst = \[CapitalLambda]mVect;
  \[CapitalLambda]mVectPesmst = \[Kappa]t (vSumt)^(1/(1-\[Rho]));

  \[CapitalKoppa]Vals = (\[CapitalLambda]VectOptmst - \[CapitalLambda]VectRealst)/(\[CapitalLambda]VectOptmst-\[CapitalLambda]VectPesmst);
  \[CapitalKoppa]\[Mu]Vals = \[FilledUpTriangle]mVect (\[CapitalLambda]mVectOptmst - \[CapitalLambda]mVectRealst)/(\[CapitalLambda]VectOptmst-\[CapitalLambda]VectPesmst);

  \[CapitalChi]Vals = Log[(1/\[CapitalKoppa]Vals)-1];
  \[CapitalChi]\[Mu]Vals = \[CapitalKoppa]\[Mu]Vals/((\[CapitalKoppa]Vals-1) \[CapitalKoppa]Vals);  (* Derivative of \[CapitalChi] wrt \[Mu] *)
 
  \[CapitalKoppa]ValsAug=Join[{\[CapitalKoppa]Vals[[1]]-\[CapitalKoppa]\[Mu]Vals[[1]]*\[Mu]SmallGapLeft}
, \[CapitalKoppa]Vals
, {\[CapitalKoppa]Vals[[-1]]+\[CapitalKoppa]\[Mu]Vals[[-1]]*\[Mu]SmallGapRight}
];
  \[CapitalKoppa]\[Mu]ValsAug=Join[{\[CapitalKoppa]\[Mu]Vals[[1]]}
, \[CapitalKoppa]\[Mu]Vals
, {\[CapitalKoppa]\[Mu]Vals[[-1]]}
];
  \[CapitalChi]ValsAug=Join[{\[CapitalChi]Vals[[1]]-\[CapitalChi]\[Mu]Vals[[1]]*\[Mu]SmallGapLeft}
, \[CapitalChi]Vals
, {\[CapitalChi]Vals[[-1]]+\[CapitalChi]\[Mu]Vals[[-1]]*\[Mu]SmallGapRight}
];
  \[CapitalChi]\[Mu]ValsAug=Join[{\[CapitalChi]\[Mu]Vals[[1]]}
, \[CapitalChi]\[Mu]Vals
, {\[CapitalChi]\[Mu]Vals[[-1]]}
];


mSmallGapLeft    =  (mVect[[1]]-mLowerBoundt)*mRatioSmallGapLeft;
mSmallGapRight   =  (mVect[[-1]]-mVect[[-2]])*mRatioSmallGapRight;

  mVectAug=Join[
  {mVect[[1]]-mSmallGapLeft}
,  mVect
, {mVect[[-1]]+mSmallGapRight}
];

\[CapitalLambda]VectAug=Join[
  {\[CapitalLambda]Vect[[1]]-\[CapitalLambda]mVect[[1]]*mSmallGapLeft}
,  \[CapitalLambda]Vect
, {\[CapitalLambda]Vect[[-1]]+\[CapitalLambda]mVect[[-1]]*mSmallGapRight}
];

\[CapitalLambda]mVectAug=Join[
 {\[CapitalLambda]mVect[[1]]}
, \[CapitalLambda]mVect
, {\[CapitalLambda]mVect[[-1]]}
];

  \[CapitalLambda]Data=Transpose[{AddBracesTo[mVectAug],\[CapitalLambda]VectAug, \[CapitalLambda]mVectAug}];
  \[CapitalKoppa]Data=Transpose[{AddBracesTo[\[Mu]VectAug],\[CapitalKoppa]ValsAug,\[CapitalKoppa]\[Mu]ValsAug}];
  \[CapitalChi]Data=Transpose[{AddBracesTo[\[Mu]VectAug],\[CapitalChi]ValsAug,\[CapitalChi]\[Mu]ValsAug}];

  AppendTo[\[CapitalLambda]FuncLife,Interpolation[\[CapitalLambda]Data]];
  AppendTo[\[CapitalKoppa]FuncLife,Interpolation[\[CapitalKoppa]Data]];
  \[CapitalChi]Func=Interpolation[\[CapitalChi]Data];
  AppendTo[\[CapitalChi]FuncLife, \[CapitalChi]Func];



];


