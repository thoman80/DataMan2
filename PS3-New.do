Galadriel Thoman
PS3 Redo
Stata Version 16

//I am doing a project on poverty in Botswana for another class, and I am interested in comparing the country to other countries in Africa statistically, as Botswana is known as the "African Exception" and considered an economic success. However, there are still several measures that is is lagging behind in. Using a combination of data from several global institutions, I want to examine if Botswana is statistically still improving and doing better than its neighbors, particulary at both the national level and at a community level (thorugh survey data).//

//First what I am doing is gathering datasets together. The four merges in the firdt part are not meant to go towards the five datasets for the assignment; I am including the steps for combining the datasets for clarity. They all came from The World Bank using the db wbopendata package through Stata so there is no direct link from a website. I had to download each topic individually, save each of those datasets, then do the following merge to create one dataset.//

use "https://docs.google.com/uc?id=1NHxZvHiHP2MAuBveg3qgY7Hhthx0_ytJ&export=download", clear
merge 1:m countryname year using "https://docs.google.com/uc?id=11g0sadMorCCs9AWlinxNUCQuwglCto1R&export=download", generate(_merge2)
merge 1:m countryname year using "https://docs.google.com/uc?id=10D8SZwx76TCFSIcg0G_SO8mgzTtOO6IZ&export=download", generate(_merge3)
merge 1:m countryname year using "https://docs.google.com/uc?id=11-CNLK7NltPyNG_-slSpvQQEjQInc2XA&export=download", generate(_merge4)

//After these initial merges, I attempted to play around with reshaping. However, even though the data was in long form, I got an error that said "data are already wide".//

//Next I am changing missing observations to 99999 so I can use those variables. There are a lot of variables so the command is very long and split into two parts.//

mvencode ag_lnd_agri_zs ag_lnd_arbl_zs ag_lnd_el5m_ru_k2 ag_lnd_el5m_ru_zs ag_lnd_el5m_ur_k2 ag_lnd_el5m_ur_zs ag_lnd_el5m_zs ag_lnd_frst_k2 ag_lnd_frst_zs ag_lnd_prcp_mm ag_lnd_totl_k2 ag_lnd_totl_ru_k2 ag_lnd_totl_ur_k2 ag_srf_totl_k2 eg_cft_accs_zs eg_egy_prim_pp_kd eg_elc_accs_zs eg_elc_fosl_zs eg_elc_rnew_zs eg_elc_rnwx_kh eg_elc_rnwx_zs eg_fec_rnew_zs en_atm_co2e_eg_zs en_atm_co2e_gf_kt en_atm_co2e_gf_zs en_atm_co2e_kd_gd en_atm_co2e_kt en_atm_co2e_lf_kt en_atm_co2e_lf_zs en_atm_co2e_pc en_atm_co2e_pp_gd en_atm_co2e_pp_gd_kd en_atm_co2e_sf_kt en_atm_co2e_sf_zs en_atm_ghgo_kt_ce en_atm_ghgo_zg en_atm_ghgt_kt_ce en_atm_ghgt_zg en_atm_hfcg_kt_ce en_atm_meth_ag_kt_ce en_atm_meth_ag_zs en_atm_meth_eg_kt_ce en_atm_meth_eg_zs en_atm_meth_eg_zs en_atm_meth_kt_ce en_atm_meth_zg en_atm_noxe_ag_kt_ce en_atm_noxe_ag_zs en_atm_noxe_eg_kt_ce en_atm_noxe_eg_zs en_atm_noxe_kt_ce en_atm_noxe_zg en_atm_pfcg_kt_ce en_atm_pfcg_kt_ce en_atm_pm25_mc_m3 en_atm_pm25_mc_zs en_atm_sf6g_kt_ce en_bir_thrd_no en_clc_drsk_xq en_clc_ghgr_mt_ce en_clc_mdat_zs en_co2_bldg_zs en_co2_etot_zs en_co2_manf_zs en_co2_othx_zs en_co2_tran_zs en_fsh_thrd_no en_hpt_thrd_no en_mam_thrd_no en_pop_el5m_ru_zs en_pop_el5m_ur_zs en_pop_el5m_zs en_pop_slum_ur_zs er_fsh_aqua_mt er_fsh_capt_mt er_fsh_prod_mt er_gdp_fwtl_m3_kd er_h2o_fwag_zs er_h2o_fwdm_zs er_h2o_fwin_zs er_h2o_fwtl_k3 er_h2o_fwtl_zs er_h2o_intr_k3 er_h2o_intr_pc er_lnd_ptld_zs er_mrn_ptmr_zs er_ptd_totl_zs ny_adj_aedu_cd ny_adj_aedu_gn_zs ny_adj_dco2_cd ny_adj_dco2_gn_zs ny_adj_dfor_cd ny_adj_dfor_gn_zs ny_adj_dkap_cd ny_adj_dkap_gn_zs, mv(999999)

mvencode ny_adj_dmin_gn_zs ny_adj_dngy_cd ny_adj_dngy_gn_zs ny_adj_dpem_gn_zs ny_adj_dpem_gn_zs ny_adj_ictr_gn_zs ny_adj_nnat_cd ny_adj_nnat_gn_zs ny_adj_svng_cd ny_adj_svng_gn_zs ny_adj_svnx_cd ny_adj_svnx_gn_zs ny_gdp_coal_rt_zs ny_gdp_frst_rt_zs ny_gdp_minr_rt_zs ny_gdp_ngas_rt_zs ny_gdp_petr_rt_zs ny_gdp_totl_rt_zs sh_h2o_basw_ru_zs sh_h2o_basw_ur_zs sh_h2o_basw_zs sh_h2o_smdw_ru_zs sh_h2o_smdw_ur_zs sh_h2o_smdw_zs sh_sta_airp_p5 sh_sta_bass_ru_zs sh_sta_bass_ur_zs sh_sta_bass_zs sh_sta_hygn_ru_zs sh_sta_hygn_ur_zs sh_sta_hygn_zs sh_sta_odfc_ru_zs sh_sta_odfc_ur_zs sh_sta_odfc_zs sh_sta_pois_p5 sh_sta_pois_p5_fe sh_sta_pois_p5_ma sh_sta_smss_ru_zs sh_sta_smss_ur_zs sh_sta_smss_zs sh_sta_wash_p5 sl_agr_0714_fe_zs sl_agr_0714_ma_zs sl_agr_0714_zs sl_agr_empl_fe_zs sl_agr_empl_ma_zs sl_agr_empl_zs sl_emp_1524_sp_fe_ne_zs sl_emp_1524_sp_fe_zs sl_emp_1524_sp_ma_ne_zs sl_emp_1524_sp_ma_zs sl_emp_1524_sp_ma_ne_zs sl_emp_1524_sp_ne_zs sl_emp_1524_sp_zs sl_emp_mpyr_fe_zs sl_emp_mpyr_ma_zs sl_emp_mpyr_zs sl_emp_self_fe_zs sl_emp_self_ma_zs sl_emp_self_zs sl_emp_smgt_fe_zs sl_emp_totl_sp_fe_ne_zs sl_emp_totl_sp_fe_zs sl_emp_totl_sp_ma_ne_zs sl_emp_totl_sp_ma_zs sl_emp_totl_sp_ne_zs sl_emp_totl_sp_zs sl_emp_vuln_fe_zs sl_emp_vuln_ma_zs sl_emp_vuln_zs sl_emp_work_fe_zs sl_emp_work_ma_zs sl_emp_work_zs sl_fam_0714_fe_zs sl_fam_0714_ma_zs sl_fam_0714_zs sl_fam_work_fe_zs sl_fam_work_ma_zs sl_fam_work_zs sl_gdp_pcap_em_kd sl_ind_empl_fe_zs sl_ind_empl_ma_zs sl_ind_empl_zs sl_isv_ifrm_fe_zs sl_isv_ifrm_ma_zs sl_isv_ifrm_zs sl_mnf_0714_fe_zs sl_mnf_0714_ma_zs sl_mnf_0714_zs sl_slf_0714_ma_zs sl_slf_0714_zs sl_srv_0714_fe_zs sl_srv_0714_ma_zs sl_srv_0714_zs sl_srv_empl_fe_zs sl_srv_empl_ma_zs sl_srv_empl_zs sl_srv_empl_zs, mv(999999)

//Next, I started with an OECD dataset called SPIDER, then kept 13 select variables (along with country and year). These variables include HIV statistics, life expectency, presence of peacekeepers, and poverty measures. The raw full dataset can be found at: https://spider-files.oecd.org/SPIDER.dta.//

merge 1:1 countryname year using "https://docs.google.com/uc?id=1Ko3RFKTN3_RZP_MBCMstHD94W3c5-4vA&export=download", generate(_merge5)

tab _merge5

mvencode agedependencyratio_old_wdi corrpt gend_female_senior_pc_wdi h_hiv_wdi hcap_pwt9 lexp65 lifeexp_wdi peacekeepers_wdi polity polstab poverty4_wdi poverty5_wdi poverty6_wdi, mv(999999)


//I am now going to merge a dataset with a huge amount of observations on poverty indicators. The link to this data is here: https://dataverse.harvard.edu/file.xhtml?persistentId=doi:10.7910/DVN/25492/XCMAAM&version=10.0. I used the force option because I do not need the region variable (the variable with the mixmatch type) so the loss of data isn't a problem.//

merge 1:m countryname year using "https://docs.google.com/uc?id=1j_XfVCjZUQ_bpb-EGWyNrhz7cPGU7Fl1&export=download", force

tab _merge

//Next I am merging a simple dataset of population over the years between 1995-2014. I downloaded the data here: https://www.gapminder.org/data/. It was downloaded in Excel format, and I imported it into Stata, after which I reshaped the data into long data. This is the output of that reshaping-included just so you can see that I do get the purpose of reshaping. I kept getting errors from pasting the table into here, so I used an excessive number of forward slashes to make sure Stata knows it is text and not a command.//

//reshape long yr, i(country) j(year)//
//(note: j = 1995 1996 1997 1998 1999 2000	2001	2002 2003	2004	2005	2006	2007	2008	2009	2010	2011	2012 2013 2014)//

//Data                               wide	->	long//
							
//Number of obs.                      195	->	3900//
//Number of variables                  21	->	3//
//j variable (20 values)	->	year//
//xij variables://
//yr1995 yr1996 ... yr2014	->	yr//



merge m:1 countryname year using "https://docs.google.com/uc?id=10z8DH1clnkQPt99qi3DNXZGkOXR9VCqK&export=download", generate(_merge6)

tab _merge6
 
//My last merge is another simple dataset of Income Per Capita (PPP-Inflation Adjusted) that I downloaded in Excel format from here: https://www.gapminder.org/data/documentation/gd001/. I again kept only the years between 1995 and 2014, and once it was imported into Stata I reshaped it into long format to match the previous merges (and for simplification of the data, obviously). This is the output from that reshaping://

//reshape long yr, i(countryname) j(year)
//(note: j = 1995 1996 1997 1998 1999 2000	2001	2002 2003	2004	2005	2006	2007 //2008	2009	2010	2011	20122013 2014)//

//Data                               wide	->	long//
							
//Number of obs.                      193	->	3860//
//Number of variables                  21	->	3//
//j variable (20 values)	->	year//
//xij variables://
//yr1995 yr1996 ... yr2014	->	yr//

merge m:1 countryname year using "https://docs.google.com/uc?id=1rMMJCD9ZxwKK2LMtQADt2HvrIdAo6zPb&export=download", generate(_merge7)

tab _merge7

//I continued to have issues with reshaping this data. However, reshaping such a large dataset to wide would create far too many variables and just make the data unwieldy. Stata says it is actually in wide format, but it's not, as the year variable illustrates. I don't know why I'm getting that error.//

//This dataset still needs to be cleaned up and organized, and the variables trimmed down once I decide which ones I want to focus on. There are still some missing values, which will also be cleaned up once I know which variables are left.//








