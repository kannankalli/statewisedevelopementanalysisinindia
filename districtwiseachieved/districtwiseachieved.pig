REGISTER /usr/local/pig/lib/piggybank.jar;
DEFINE XPath org.apache.pig.piggybank.evaluation.xml.XPath;

-- loading data from xml to Relation S
S = load '/flume_data/StatewiseDistrictwisePhysicalProgress.xml' 
using org.apache.pig.piggybank.storage.XMLLoader('row') as (x:chararray);

-- fetc state,district name,project object BPL and project performance of BPL
SOCIAL_DATA = foreach S generate XPath(x,'/row/State_Name') as state, 
XPath(x,'/row/District_Name') as DistrictName,
XPath(x,'/row/Project_Objectives_IHHL_BPL') as POIHHLBPL,
XPath(x,'/row/Project_Performance-IHHL_BPL') as PPIHHLBPL;

-- filter which is not null 
SOCIAL_DATA_FILTERED = filter SOCIAL_DATA by (PPIHHLBPL is not null) AND (POIHHLBPL is not null);

-- filter with project objective should be grater than project performance then those district is achieved
SOCIAL_DATA_FILTERED_1 = filter SOCIAL_DATA_FILTERED by ((int)PPIHHLBPL >=  (int)POIHHLBPL);

-- fetch only required column
SOCIAL_DATA_3 = foreach SOCIAL_DATA_FILTERED_1 generate state,DistrictName,POIHHLBPL,PPIHHLBPL;

--- store the data into hdfs
store SOCIAL_DATA_3 into '/flume_data/districtwiseachieved';

