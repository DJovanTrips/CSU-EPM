filename csv '/folders/myfolders/sasuser.v94/clothing_store_mod8.CSV';

proc import datafile=csv
  out=MIS543.PM8CLStore
  dbms=csv
  replace;
run;

/*DESCRIPTIVE STATS*/ /*DESCRIPTIVE STATS*/ /*DESCRIPTIVE STATS*/ /*DESCRIPTIVE STATS*/ /*DESCRIPTIVE STATS*/ 


proc means data=MIS543.PM8CLStore;
title 'Proc Means of Clothing Store';
run;

proc univariate normal plot data=MIS543.PM8CLStore;
title 'Basic Statistic Charts';
	VAR MON;
run;

proc univariate normal plot data=MIS543.PM8CLStore;
title 'Basic Statistic Charts';
	VAR PROMOS;
run;

ods noproctitle;
ods graphics / imagemap=on;
proc corr data=MIS543.PM8CLStore pearson nosimple noprob 
	plots(maxpoints=30000) plots=scatter(ellipse=none);
	var PROMOS FRE CC_CARD CLUSTYPE AVRG GMP DAYS PERCRET ln_days_between_purchases ln_lifetime_ave_time_betw_visits;
	with MON;
run;

proc corr data=MIS543.PM8CLSTORE pearson nosimple noprob plots=none;
	var MON PROMOS FRE CC_CARD CLUSTYPE AVRG GMP DAYS PERCRET ln_days_between_purchases ln_lifetime_ave_time_betw_visits;
run;
	
	
ods noproctitle;
ods graphics / imagemap=on;

proc corr data=MIS543.PM8CLSTORE pearson nosimple noprob plots=none;
	var PSWEATERS PSHIRTS PKNIT_TOPS PKNIT_DRES PBLOUSES PJACKETS PCAR_PNTS 
		PCAS_PNTS PDRESSES POUTERWEAR PJEWELRY PSUITS PFASHION PLEGWEAR PCOLLSPND 
		PERCRET ln_days_between_purchases ln_lifetime_ave_time_betw_visits CC_CARD 
		MARKDOWN DAYS AVRG MON PROMOS FRE;
	with GMP;
run;

/*PREDICTIVE STATS*/ /*PREDICTIVE STATS*/ /*PREDICTIVE STATS*/ /*PREDICTIVE STATS*/

proc reg data=MIS543.PM8CLStore plots(maxpoints=30000);
	model MON=PROMOS FRE CC_CARD CLUSTYPE AVRG GMP DAYS PERCRET ln_days_between_purchases ln_lifetime_ave_time_betw_visits / selection=forward;
run;


proc reg data=MIS543.PM8CLStore plots(maxpoints=30000);
	model GMP= PSWEATERS PSHIRTS PKNIT_TOPS PKNIT_DRES PBLOUSES PJACKETS PCAR_PNTS 
		PCAS_PNTS PDRESSES POUTERWEAR PJEWELRY PSUITS PFASHION PLEGWEAR PCOLLSPND 
		PERCRET ln_days_between_purchases ln_lifetime_ave_time_betw_visits CC_CARD 
		MARKDOWN DAYS AVRG MON PROMOS FRE / selection=forward;
run;

proc sort data=MIS543.PM8CLStore;
by CLUSTYPE;
run;
proc anova data=MIS543.PM8CLStore plots(maxpoints=30000);
	Class CLUSTYPE;
	Model AVRG=CLUSTYPE;
	means CLUSTYPE/Tukey;
	title "Compare AVG Spend Across Clusters";
run;


proc anova data=MIS543.PM8CLStore plots(maxpoints=30000);
	Class CLUSTYPE;
	Model PROMOS=CLUSTYPE;
	means CLUSTYPE/Tukey;
	title "Compare PROMOS Across Clusters";
run;

proc sort data=MIS543.PM8CLStore;
by CLUSTYPE;
run;

proc anova data=MIS543.PM8CLStore plots(maxpoints=30000);
	Class CLUSTYPE;
	Model MON=CLUSTYPE;
	means CLUSTYPE/Tukey;
	title "Compare Total Spend Across CLUSTYPE";
run;

/*CHARTS AND VISUALS*/
/*CHARTS AND VISUALS*/
/*CHARTS AND VISUALS*/
ods graphics / reset width=6.4in height=4.8in imagemap;

proc sgplot data=MIS543.PM8CLSTORE;
	scatter x=PROMOS y=FRE /;
	xaxis grid;
	yaxis grid;
run;

ods graphics / reset;
proc boxplot data=MIS543.PM8CLStore;
plot PROMOS*CLUSTYPE / cboxes=darkgreen;
run;

proc boxplot data=MIS543.PM8CLStore;
plot AVRG*CLUSTYPE / cboxes=darkgreen;
run;

proc boxplot data=MIS543.PM8CLStore;
plot MON*CC_CARD / cboxes=darkgreen;
run;

proc boxplot data=MIS543.PM8CLStore;
plot MON*CLUSTYPE / cboxes=bibg;
run;

ods graphics / reset width=6.4in height=4.8in imagemap;

proc sgplot data=MIS543.PM8CLSTORE;
	title height=14pt "Total Sales by Number of Promos Received";
	vbar PROMOS / response=MON fillattrs=(color=CX279e31);
	yaxis grid;
run;

ods graphics / reset;
title;
	
ods graphics / reset width=6.4in height=4.8in imagemap;

proc sgplot data=MIS543.PM8CLSTORE;
	title height=14pt "Frequency by Number of Promos Received";
	vbar PROMOS / response=FRE fillattrs=(color=CXec9a20) limits=both 
		limitstat=clm stat=mean;
	yaxis grid;
run;
ods graphics / reset width=6.4in height=4.8in imagemap;

proc sgplot data=MIS543.PM8CLSTORE;
	title height=14pt "Mean Sales by Promo Count and Customer Cluster";
	heatmap x=CLUSTYPE y=PROMOS / name='HeatMap' discretex discretey 
		colormodel=(CXFFFFFF CX00DF00 CXFFFF00 CXDF0000) colorresponse=MON 
		colorstat=mean;
	gradlegend 'HeatMap';
run;

ods graphics / reset;
title;


ods graphics / reset;
title;

ods graphics / reset width=6.4in height=4.8in imagemap;

proc sgplot data=MIS543.PM8CLSTORE;
	title height=14pt "AVG Sale Number of Promos Received";
	vbar PROMOS / response=AVRG fillattrs=(color=CX20ec42) limits=both 
		limitstat=clm stat=mean;
	yaxis grid;
run;

ods graphics / reset;
title;

ods graphics / reset width=6.4in height=4.8in imagemap;

proc sgplot data=MIS543.PM8CLSTORE;
	title height=12pt "Tenure Number of Promos Received";
	vbar PROMOS / response=DAYS fillattrs=(color=CXf8444a) limits=both 
		limitstat=clm stat=mean;
	yaxis grid;
run;

ods graphics / reset;
title;

/* FOR BAR LINE CHART Compute axis ranges */
proc means data=MIS543.PM8CLSTORE noprint;
	class PROMOS / order=data;
	var MON Customer_Id;
	output out=_BarLine_(where=(_type_ > 0)) sum(MON Customer_Id)=resp1 resp2;
run;

/* Compute response min and max values (include 0 in computations) */
data _null_;
	retain respmin 0 respmax 0;
	retain respmin1 0 respmax1 0 respmin2 0 respmax2 0;
	set _BarLine_ end=last;
	respmin1=min(respmin1, resp1);
	respmin2=min(respmin2, resp2);
	respmax1=max(respmax1, resp1);
	respmax2=max(respmax2, resp2);

	if last then
		do;
			call symputx ("respmin1", respmin1);
			call symputx ("respmax1", respmax1);
			call symputx ("respmin2", respmin2);
			call symputx ("respmax2", respmax2);
			call symputx ("respmin", min(respmin1, respmin2));
			call symputx ("respmax", max(respmax1, respmax2));
		end;
run;

/* Define a macro for offset */
%macro offset ();
	%if %sysevalf(&respmin eq 0) %then
		%do;
			offsetmin=0 %end;

	%if %sysevalf(&respmax eq 0) %then
		%do;
			offsetmax=0 %end;
%mend offset;

ods graphics / reset width=6.4in height=4.8in imagemap;

proc sgplot data=MIS543.PM8CLSTORE nocycleattrs;
	title height=14pt "Total Sales and Count of Customer by Promos Received";
	vbar PROMOS / response=MON fillattrs=(color=CX0c8555) stat=sum;
	vline PROMOS / response=Customer_Id lineattrs=(thickness=2 color=CX003399) 
		stat=sum y2axis;
	yaxis grid min=&respmin1 max=&respmax1 %offset();
	y2axis min=&respmin2 max=&respmax2 %offset();
	keylegend / location=outside;
run;

ods graphics / reset;
title;

proc datasets library=WORK noprint;
	delete _BarLine_;
	run; /* END BAR LINE CHART*/

ods noproctitle;
ods graphics / imagemap=on;
proc corr data=MIS543.PM8CLStore pearson nosimple noprob 
	plots(maxpoints=30000) plots=scatter(ellipse=none);
	var PROMOS MON FRE CC_CARD CLUSTYPE AVRG GMP DAYS PERCRET ln_days_between_purchases ln_lifetime_ave_time_betw_visits;
run;

ods graphics / reset width=6.4in height=4.8in imagemap;

proc sgplot data=MIS543.PM8CLSTORE;
	title height=14pt "Count of Customer by Number of Promos Received";
	histogram PROMOS / scale=count fillattrs=(color=CX951abb);
	xaxis valuesrotate=vertical;
	yaxis grid;
run;
/* Compute axis ranges */
proc means data=MIS543.PM8CLSTORE noprint;
	class CLUSTYPE / order=data;
	var MON PROMOS;
	output out=_BarLine_(where=(_type_ > 0)) mean(MON PROMOS)=resp1 resp2;
run;

/* Compute response min and max values (include 0 in computations) */
data _null_;
	retain respmin 0 respmax 0;
	retain respmin1 0 respmax1 0 respmin2 0 respmax2 0;
	set _BarLine_ end=last;
	respmin1=min(respmin1, resp1);
	respmin2=min(respmin2, resp2);
	respmax1=max(respmax1, resp1);
	respmax2=max(respmax2, resp2);

	if last then
		do;
			call symputx ("respmin1", respmin1);
			call symputx ("respmax1", respmax1);
			call symputx ("respmin2", respmin2);
			call symputx ("respmax2", respmax2);
			call symputx ("respmin", min(respmin1, respmin2));
			call symputx ("respmax", max(respmax1, respmax2));
		end;
run;

/* Define a macro for offset */
%macro offset ();
	%if %sysevalf(&respmin eq 0) %then
		%do;
			offsetmin=0 %end;

	%if %sysevalf(&respmax eq 0) %then
		%do;
			offsetmax=0 %end;
%mend offset;

ods graphics / reset width=6.4in height=4.8in imagemap;

proc sgplot data=MIS543.PM8CLSTORE nocycleattrs;
	title height=14pt "Total Sales and Promos by Cluster";
	vbar CLUSTYPE / response=MON fillattrs=(color=CX1fc14f) stat=mean;
	vline CLUSTYPE / response=PROMOS lineattrs=(color=CX003399) stat=mean y2axis;
	yaxis grid min=&respmin1 max=&respmax1 %offset();
	y2axis min=&respmin2 max=&respmax2 %offset();
	keylegend / location=outside;
run;

ods graphics / reset;
title;

proc datasets library=WORK noprint;
	delete _BarLine_;
	run;
	
ods graphics / reset;
title;

ods graphics / reset width=6.4in height=4.8in imagemap;

proc sgplot data=MIS543.PM8CLSTORE;
	title height=14pt "Comparison of Credit Card Use by Number of Promos";
	vbox PROMOS / category=CC_CARD fillattrs=(color=CX962bdd);
	yaxis grid;
run;

ods graphics / reset;
title;
ods graphics / reset width=6.4in height=4.8in imagemap;

proc sgplot data=MIS543.PM8CLSTORE;
	title height=14pt "Comparison of Tenure by Credit Card Use";
	vbox DAYS / category=CC_CARD boxwidth=0.6 fillattrs=(color=CXdd2b2b);
	yaxis grid;
run;

ods graphics / reset;
title;

/* Compute axis ranges */
proc means data=MIS543.PM8CLSTORE noprint;
	class PROMOS / order=data;
	var AVRG FRE;
	output out=_BarLine_(where=(_type_ > 0)) mean(AVRG FRE)=resp1 resp2;
run;

/* Compute response min and max values (include 0 in computations) */
data _null_;
	retain respmin 0 respmax 0;
	retain respmin1 0 respmax1 0 respmin2 0 respmax2 0;
	set _BarLine_ end=last;
	respmin1=min(respmin1, resp1);
	respmin2=min(respmin2, resp2);
	respmax1=max(respmax1, resp1);
	respmax2=max(respmax2, resp2);

	if last then
		do;
			call symputx ("respmin1", respmin1);
			call symputx ("respmax1", respmax1);
			call symputx ("respmin2", respmin2);
			call symputx ("respmax2", respmax2);
			call symputx ("respmin", min(respmin1, respmin2));
			call symputx ("respmax", max(respmax1, respmax2));
		end;
run;

/* Define a macro for offset */
%macro offset ();
	%if %sysevalf(&respmin eq 0) %then
		%do;
			offsetmin=0 %end;

	%if %sysevalf(&respmax eq 0) %then
		%do;
			offsetmax=0 %end;
%mend offset;

ods graphics / reset width=6.4in height=4.8in imagemap;

proc sgplot data=MIS543.PM8CLSTORE nocycleattrs;
	title height=14pt "Mean Avg Sale and Mean Frequency by Number of Promos";
	vbar PROMOS / response=AVRG fillattrs=(color=CX15e450) stat=mean;
	vline PROMOS / response=FRE lineattrs=(thickness=2 color=CX9415dd) stat=mean 
		y2axis;
	yaxis grid min=&respmin1 max=&respmax1 %offset();
	y2axis min=&respmin2 max=&respmax2 %offset();
	keylegend / location=outside;
run;

ods graphics / reset;
title;

proc datasets library=WORK noprint;
	delete _BarLine_;
	run;

ods graphics / reset width=6.4in height=4.8in imagemap;

proc sgplot data=MIS543.PM8CLSTORE;
	title height=14pt "Average Sales by Cluster and Promos";
	heatmap x=CLUSTYPE y=PROMOS / name='HeatMap' discretex discretey 
		colorresponse=MON colorstat=mean;
	gradlegend 'HeatMap';
run;

ods graphics / reset;
title;

/* Compute axis ranges */
proc means data=MIS543.PM8CLSTORE noprint;
	class CLUSTYPE / order=data;
	var PROMOS Customer_Id;
	output out=_BarLine_(where=(_type_ > 0)) sum(PROMOS Customer_Id)=resp1 resp2;
run;

/* Compute response min and max values (include 0 in computations) */
data _null_;
	retain respmin 0 respmax 0;
	retain respmin1 0 respmax1 0 respmin2 0 respmax2 0;
	set _BarLine_ end=last;
	respmin1=min(respmin1, resp1);
	respmin2=min(respmin2, resp2);
	respmax1=max(respmax1, resp1);
	respmax2=max(respmax2, resp2);

	if last then
		do;
			call symputx ("respmin1", respmin1);
			call symputx ("respmax1", respmax1);
			call symputx ("respmin2", respmin2);
			call symputx ("respmax2", respmax2);
			call symputx ("respmin", min(respmin1, respmin2));
			call symputx ("respmax", max(respmax1, respmax2));
		end;
run;

/* Define a macro for offset */
%macro offset ();
	%if %sysevalf(&respmin eq 0) %then
		%do;
			offsetmin=0 %end;

	%if %sysevalf(&respmax eq 0) %then
		%do;
			offsetmax=0 %end;
%mend offset;

ods graphics / reset width=6.4in height=4.8in imagemap;

proc sgplot data=MIS543.PM8CLSTORE nocycleattrs;
	title height=14pt "Total Promos and Customers by Cluster Type";
	vbar CLUSTYPE / response=PROMOS fillattrs=(color=CX1561e4) stat=sum;
	vline CLUSTYPE / response=Customer_Id lineattrs=(thickness=2 color=CX151bdd) 
		stat=sum y2axis;
	yaxis grid min=&respmin1 max=&respmax1 %offset();
	y2axis min=&respmin2 max=&respmax2 %offset();
	keylegend / location=outside;
run;

ods graphics / reset;
title;

proc datasets library=WORK noprint;
	delete _BarLine_;
	run;

proc sort data=MIS543.PM8CLSTORE out=_BarLineChartTaskData;
	by CC_CARD;
run;

/* Compute axis ranges */
proc means data=_BarLineChartTaskData noprint;
	by CC_CARD;
	class PROMOS / order=data;
	var MON FRE;
	output out=_BarLine_(where=(_type_ > 0)) sum(MON)=resp1 mean(FRE)=resp2;
run;

/* Compute response min and max values (include 0 in computations) */
data _null_;
	retain respmin 0 respmax 0;
	retain respmin1 0 respmax1 0 respmin2 0 respmax2 0;
	set _BarLine_ end=last;
	respmin1=min(respmin1, resp1);
	respmin2=min(respmin2, resp2);
	respmax1=max(respmax1, resp1);
	respmax2=max(respmax2, resp2);

	if last then
		do;
			call symputx ("respmin1", respmin1);
			call symputx ("respmax1", respmax1);
			call symputx ("respmin2", respmin2);
			call symputx ("respmax2", respmax2);
			call symputx ("respmin", min(respmin1, respmin2));
			call symputx ("respmax", max(respmax1, respmax2));
		end;
run;

/* Define a macro for offset */
%macro offset ();
	%if %sysevalf(&respmin eq 0) %then
		%do;
			offsetmin=0 %end;

	%if %sysevalf(&respmax eq 0) %then
		%do;
			offsetmax=0 %end;
%mend offset;

ods graphics / reset width=6.4in height=4.8in imagemap;

proc sgplot data=_BarLineChartTaskData nocycleattrs;
	by CC_CARD;
	title height=14pt "Total Sales by Promos Received - Use of Credit";
	vbar PROMOS / response=MON fillattrs=(color=CX009b09) stat=sum;
	vline PROMOS / response=FRE lineattrs=(thickness=2 color=CX003399) stat=mean 
		y2axis;
	yaxis grid min=&respmin1 max=&respmax1 %offset();
	y2axis min=&respmin2 max=&respmax2 %offset();
	keylegend / location=outside;
run;

ods graphics / reset;
title;

proc datasets library=WORK noprint;
	delete _BarLine_ _BarLineChartTaskData;
	run;
proc sort data=MIS543.PM8CLSTORE out=_BarLineChartTaskData;
	by CC_CARD;
run;

/* Compute axis ranges */
proc means data=_BarLineChartTaskData noprint;
	by CC_CARD;
	class CLUSTYPE / order=data;
	var PROMOS MON;
	output out=_BarLine_(where=(_type_ > 0)) mean(PROMOS MON)=resp1 resp2;
run;

/* Compute response min and max values (include 0 in computations) */
data _null_;
	retain respmin 0 respmax 0;
	retain respmin1 0 respmax1 0 respmin2 0 respmax2 0;
	set _BarLine_ end=last;
	respmin1=min(respmin1, resp1);
	respmin2=min(respmin2, resp2);
	respmax1=max(respmax1, resp1);
	respmax2=max(respmax2, resp2);

	if last then
		do;
			call symputx ("respmin1", respmin1);
			call symputx ("respmax1", respmax1);
			call symputx ("respmin2", respmin2);
			call symputx ("respmax2", respmax2);
			call symputx ("respmin", min(respmin1, respmin2));
			call symputx ("respmax", max(respmax1, respmax2));
		end;
run;

/* Define a macro for offset */
%macro offset ();
	%if %sysevalf(&respmin eq 0) %then
		%do;
			offsetmin=0 %end;

	%if %sysevalf(&respmax eq 0) %then
		%do;
			offsetmax=0 %end;
%mend offset;

ods graphics / reset width=6.4in height=4.8in imagemap;

proc sgplot data=_BarLineChartTaskData nocycleattrs;
	by CC_CARD;
	title height=14pt "Mean Promos and Sales by Cluster- Use of Credit";
	vbar CLUSTYPE / response=PROMOS fillattrs=(color=CX00649b) stat=mean;
	vline CLUSTYPE / response=MON lineattrs=(thickness=2 color=CX00b128) stat=mean 
		y2axis;
	yaxis grid min=&respmin1 max=&respmax1 %offset();
	y2axis min=&respmin2 max=&respmax2 %offset();
	keylegend / location=outside;
run;

ods graphics / reset;
title;

proc datasets library=WORK noprint;
	delete _BarLine_ _BarLineChartTaskData;
	run;
/*WRAP UP CODE*/	
/*WRAP UP CODE*/
/*WRAP UP CODE*/
/*WRAP UP CODE*/

	/* Compute axis ranges */
proc means data=MIS543.PM8CLSTORE noprint;
	class PROMOS / order=data;
	var MON FRE;
	output out=_BarLine_(where=(_type_ > 0)) mean(MON FRE)=resp1 resp2;
run;

/* Compute response min and max values (include 0 in computations) */
data _null_;
	retain respmin 0 respmax 0;
	retain respmin1 0 respmax1 0 respmin2 0 respmax2 0;
	set _BarLine_ end=last;
	respmin1=min(respmin1, resp1);
	respmin2=min(respmin2, resp2);
	respmax1=max(respmax1, resp1);
	respmax2=max(respmax2, resp2);

	if last then
		do;
			call symputx ("respmin1", respmin1);
			call symputx ("respmax1", respmax1);
			call symputx ("respmin2", respmin2);
			call symputx ("respmax2", respmax2);
			call symputx ("respmin", min(respmin1, respmin2));
			call symputx ("respmax", max(respmax1, respmax2));
		end;
run;

/* Define a macro for offset */
%macro offset ();
	%if %sysevalf(&respmin eq 0) %then
		%do;
			offsetmin=0 %end;

	%if %sysevalf(&respmax eq 0) %then
		%do;
			offsetmax=0 %end;
%mend offset;

ods graphics / reset width=6.4in height=4.8in imagemap;

proc sgplot data=MIS543.PM8CLSTORE nocycleattrs;
	title height=12pt "Mean Sales and Mean Frequency by Count of Promos Received";
	vbar PROMOS / response=MON fillattrs=(color=CX44cf11) stat=mean;
	vline PROMOS / response=FRE lineattrs=(thickness=2 color=CX003399) stat=mean 
		y2axis;
	yaxis grid min=&respmin1 max=&respmax1 %offset();
	y2axis min=&respmin2 max=&respmax2 %offset();
	keylegend / location=outside;
run;

ods graphics / reset;
title;

proc datasets library=WORK noprint;
	delete _BarLine_;
	run;
	title;
ods noproctitle;
ods graphics / imagemap=on;

proc glm data=MIS543.PM8CLSTORE;
	class PROMOS;
	model MON=PROMOS CC_CARD CC_CARD * PROMOS;
	lsmeans PROMOS / adjust=tukey pdiff alpha=.05;
quit;
/* Compute axis ranges */
proc means data=MIS543.PM8CLSTORE noprint;
	class PROMOS CC_CARD / order=data;
	var MON FRE;
	output out=_BarLine_(where=(_type_ > 2)) sum(MON)=resp1 mean(FRE)=resp2;
run;

/* Compute response min and max values (include 0 in computations) */
data _null_;
	retain respmin 0 respmax 0;
	retain respmin1 0 respmax1 0 respmin2 0 respmax2 0;
	set _BarLine_ end=last;
	respmin1=min(respmin1, resp1);
	respmin2=min(respmin2, resp2);
	respmax1=max(respmax1, resp1);
	respmax2=max(respmax2, resp2);

	if last then
		do;
			call symputx ("respmin1", respmin1);
			call symputx ("respmax1", respmax1);
			call symputx ("respmin2", respmin2);
			call symputx ("respmax2", respmax2);
			call symputx ("respmin", min(respmin1, respmin2));
			call symputx ("respmax", max(respmax1, respmax2));
		end;
run;

/* Define a macro for offset */
%macro offset ();
	%if %sysevalf(&respmin eq 0) %then
		%do;
			offsetmin=0 %end;

	%if %sysevalf(&respmax eq 0) %then
		%do;
			offsetmax=0 %end;
%mend offset;

ods graphics / reset width=6.4in height=4.8in imagemap;

proc sgplot data=MIS543.PM8CLSTORE nocycleattrs;
	title height=12pt 
		"Total Sales and Average Visits by Promos (Split by Credit Card)";
	vbar PROMOS / response=MON group=CC_CARD groupdisplay=cluster 
		fillattrs=(transparency=0.5) stat=sum;
	vline PROMOS / response=FRE group=CC_CARD lineattrs=(thickness=2) stat=mean 
		y2axis;
	yaxis grid min=&respmin1 max=&respmax1 %offset();
	y2axis min=&respmin2 max=&respmax2 %offset();
	keylegend / location=outside;
run;

ods graphics / reset;
title;

proc datasets library=WORK noprint;
	delete _BarLine_;
	run;
	/* Compute axis ranges */
proc means data=MIS543.PM8CLSTORE noprint;
	class PROMOS CC_CARD / order=data;
	var MON DAYS;
	output out=_BarLine_(where=(_type_ > 2)) sum(MON)=resp1 mean(DAYS)=resp2;
run;

/* Compute response min and max values (include 0 in computations) */
data _null_;
	retain respmin 0 respmax 0;
	retain respmin1 0 respmax1 0 respmin2 0 respmax2 0;
	set _BarLine_ end=last;
	respmin1=min(respmin1, resp1);
	respmin2=min(respmin2, resp2);
	respmax1=max(respmax1, resp1);
	respmax2=max(respmax2, resp2);

	if last then
		do;
			call symputx ("respmin1", respmin1);
			call symputx ("respmax1", respmax1);
			call symputx ("respmin2", respmin2);
			call symputx ("respmax2", respmax2);
			call symputx ("respmin", min(respmin1, respmin2));
			call symputx ("respmax", max(respmax1, respmax2));
		end;
run;

/* Define a macro for offset */
%macro offset ();
	%if %sysevalf(&respmin eq 0) %then
		%do;
			offsetmin=0 %end;

	%if %sysevalf(&respmax eq 0) %then
		%do;
			offsetmax=0 %end;
%mend offset;

ods graphics / reset width=6.4in height=4.8in imagemap;

proc sgplot data=MIS543.PM8CLSTORE nocycleattrs;
	title height=12pt 
		"Total Sales and Average Tenure by Promos (Split by Credit Card)";
	vbar PROMOS / response=MON group=CC_CARD groupdisplay=cluster 
		fillattrs=(transparency=0.5) stat=sum;
	vline PROMOS / response=DAYS group=CC_CARD lineattrs=(thickness=2) stat=mean 
		y2axis;
	yaxis grid min=&respmin1 max=&respmax1 %offset();
	y2axis min=&respmin2 max=&respmax2 %offset();
	keylegend / location=outside;
run;

ods graphics / reset;
title;

proc datasets library=WORK noprint;
	delete _BarLine_;
	run;