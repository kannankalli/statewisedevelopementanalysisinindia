REGISTER /usr/local/pig/lib/piggybank.jar;
DEFINE XPath org.apache.pig.piggybank.evaluation.xml.XPath;

REGISTER /home/acadgild/Downloads/PIGUDF.jar;

-- loading data from xml to Relation S
S = load '/flume_data/StatewiseDistrictwisePhysicalProgress.xml' 
using org.apache.pig.piggybank.storage.XMLLoader('row') as (x:chararray);

-- fetc state,district name,project object BPL and project performance of BPL
SOCIAL_DATA = foreach S generate XPath(x,'/row/State_Name') as state, 
XPath(x,'/row/District_Name') as DistrictName,
XPath(x,'/row/Project_Objectives_IHHL_BPL') as POIHHLBPL,
XPath(x,'/row/Project_Performance-IHHL_BPL') as PPIHHLBPL;

-- filter social data using custom filter which is more than 80 percent project performance achived
SOCIAL_DATA_FILTERED = filter SOCIAL_DATA by com.bigdata.acadgild.PigCustomFilter(PPIHHLBPL,POIHHLBPL);

-- filtering all required columns
SOCIAL_DATA_F = foreach SOCIAL_DATA_FILTERED generate state,DistrictName,PPIHHLBPL,POIHHLBPL;

-- store output data into hdfs
store SOCIAL_DATA_F into '/flume_data/bplacheived80';


