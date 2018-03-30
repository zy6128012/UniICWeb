﻿using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using UniWebLib;
using UniStruct;
using System.Xml;
using System.Text;


public partial class Page_Search : UniPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        REQUESTCODE uResponse = REQUESTCODE.EXECUTE_FAIL;


        YARDRESVCHECKINFOREQ vrPar = new YARDRESVCHECKINFOREQ();
        string szCheckIDs = Request["ID"];
        if(m_szScript==null)
        {
              Response.Write("传递值有问题");
            return;
        }
        string[] szCheckIDList = szCheckIDs.ToString().Split(',');
        for (int i = 0; i < szCheckIDList.Length; i++)
        {
            uint uCheckID = Parse(szCheckIDList[i]);
            if (uCheckID == 0)
            {
                continue;
            }
            vrPar.dwCheckID = uCheckID;

            vrPar.dwNeedYardResv = 1;
            // vrPar.dwStatus = (uint)ADMINCHECK.DWCHECKSTAT.CHECKSTAT_NONE;
            //vrPar.dwAuthType = (uint)SYSFUNCRULE.DWAUTHTYPE.AUTHBY_REARCHTEST;
            string szvApplyAgain = Request["vApplyAgain"];
            string szCheckInfo = Request["szCheckInfo"];
            YARDRESVCHECKINFO[] vtRes;
            uResponse = m_Request.Reserve.GetYardResvCheckInfo(vrPar, out vtRes);

            if (uResponse == REQUESTCODE.EXECUTE_SUCCESS == vtRes.Length > 0)
            {

                YARDRESVCHECK setValue = new YARDRESVCHECK();
                setValue.dwCheckID = vtRes[0].dwCheckID;
                setValue.dwCheckKind = vtRes[0].dwCheckKind;
                setValue.dwResvID = vtRes[0].dwResvID;
                setValue.szCheckDetail = Request["szCheckInfo"];
                setValue.YardResv = vtRes[0].YardResv;
                string szCheckName = Request["checkstate"];
                if (szCheckName == "16")
                {
                    setValue.dwCheckStat = (uint)ADMINCHECK.DWCHECKSTAT.CHECKSTAT_FAIL;

                }
                else
                {
                    setValue.dwCheckStat = (uint)ADMINCHECK.DWCHECKSTAT.CHECKSTAT_FAIL + (uint)ADMINCHECK.DWCHECKSTAT.CHECKSTAT_REDO;

                }

                uResponse = m_Request.Reserve.YardResvCheck(setValue);
            }
        }
            if (uResponse == REQUESTCODE.EXECUTE_SUCCESS)
            {
                Session["checkid"] = szCheckIDs;
                Response.Write("success");
            }
            else
            {

                Response.Write(m_Request.szErrMessage.ToString());
            }
       
    }
   
}
