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

public partial class Sub_Lab : UniPage
{
    protected string m_szOpts = "";
    protected MyString m_szOut = new MyString();
    
    protected void Page_Load(object sender, EventArgs e)
    {
        RESVREQ vrParameter = new RESVREQ();
        string szCheckStat = Request["dwCheckStat"];
        string szKey = Request["szGetKey"];
        if (szKey != null && szKey != "")
        {
            //vrParameter.dwGetType = (uint)RESVREQ.DWGETTYPE.RESVGET_BYDEVID;
            vrParameter.dwDevID = Parse(szKey);
        }
        string szResvID = Request["delID"];
        if (szResvID != null && szResvID != "")
        {
            DelResv(szResvID);
        }
        if (!IsPostBack)
        {
            vrParameter.dwBeginDate = GetDate(DateTime.Now.AddDays(0).ToString("yyyy-MM-dd"));
            vrParameter.dwEndDate = GetDate(DateTime.Now.AddDays(0).ToString("yyyy-MM-dd"));

            dwStartDate.Value = DateTime.Now.AddDays(0).ToString("yyyy-MM-dd");
            dwEndDate.Value = DateTime.Now.AddDays(0).ToString("yyyy-MM-dd");
        }
        if (dwStartDate.Value != "" && dwEndDate.Value != "")
        {
            vrParameter.dwBeginDate = GetDate(dwStartDate.Value);
            vrParameter.dwEndDate = GetDate(dwEndDate.Value);
        }
      //  vrParameter.dwClassKind = (uint)UNIDEVCLS.DWKIND.CLSKIND_COMMONS;
        vrParameter.dwPurpose = (uint)UNIRESERVE.DWPURPOSE.USEFOR_PERSONNAL;
        if (!(szCheckStat == null || szCheckStat == "" || szCheckStat == "0"))
        {
            vrParameter.dwCheckStat = Parse(szCheckStat);
        }
        string dwPID = Request["dwPID"];
        if (dwPID != null && dwPID != "")
        {
            UNIACCOUNT accinfo;
            int nCount=0;
            if(GetAccByLogonName(dwPID,out accinfo,out nCount)&&nCount==1)
            {
                vrParameter.dwOwner = accinfo.dwAccNo;
            }
            
        }
        string dwPIDOther = Request["dwPIDOther"];
        if (dwPIDOther != null && dwPIDOther != "")
        {
            UNIACCOUNT accinfo;
            int nCount=0;
            if (GetAccByLogonName(dwPIDOther, out accinfo, out nCount) && nCount == 1)
            {
                vrParameter.dwAccNo = accinfo.dwAccNo;
            }
            
        }

        vrParameter.dwStatFlag = (uint)RESVREQ.DWSTATFLAG.STATFLAG_INUSE + (uint)RESVREQ.DWSTATFLAG.STATFLAG_OVER;
        UNIRESERVE[] vrResult;       
        GetPageCtrlValue(out vrParameter.szReqExtInfo);
        if (vrParameter.szReqExtInfo.szOrderKey == null)
        {
            vrParameter.szReqExtInfo.szOrderKey = "dwBeginTime";
            vrParameter.szReqExtInfo.szOrderMode = "asc";
        }
        if (m_Request.Reserve.Get(vrParameter, out vrResult) == REQUESTCODE.EXECUTE_SUCCESS)
        {
            int count = 0;
            uint uTimeNow = Get1970Seconds(DateTime.Now.ToString("yyyy-MM-dd HH:mm"));
            for (int i = 0; i < vrResult.Length; i++)
            {
                uint uState = (uint)vrResult[i].dwStatus;                               
                m_szOut += "<tr>";
                m_szOut += "<td data-id=\"" + vrResult[i].dwResvID.ToString() + "\">" + vrResult[i].dwResvID.ToString() + "</td>";
                m_szOut += "<td class='lnkAccount' data-id='" + vrResult[i].dwOwner.ToString() + "' title='查看个人信息'><a href=\"#\">" + vrResult[i].szOwnerName.ToString() + "</a></td>";                
                m_szOut += "<td>" + vrResult[i].ResvDev[0].szDevName+ "</td>";                
                m_szOut += "<td>" + vrResult[i].szLabName.ToString() + "</td>";
                m_szOut += "<td>" + GetJustName((vrResult[i].dwStatus), "Reserve_Status") + "</td>";
                m_szOut += "<td>" + Get1970Date((uint)vrResult[i].dwOccurTime, "MM-dd HH:mm") + "</td>";
                m_szOut += "<td>" + Get1970Date((uint)vrResult[i].dwBeginTime, "MM-dd HH:mm") + "到" + Get1970Date((uint)vrResult[i].dwEndTime, "MM-dd HH:mm") + "</td>";
                string szOp = "";
               // if ((uState & ((uint)ADMINCHECK.DWCHECKSTAT.CHECKSTAT_CANDO)) > 0)
                {
                    //szOp = "'OPTD OPTDCheck'";
                }
               // else
                {
                    szOp = "OPTD";
                }
                m_szOut += "<td><div class=" + szOp + "></div></td>";
                m_szOut += "</tr>";
            }
            UpdatePageCtrl(m_Request.Reserve);
        }
        PutBackValue();
    }
    protected void DelResv(string szResvID)
    {
        UNIRESERVE delResv = new UNIRESERVE();
        delResv.dwResvID = Parse(szResvID);
        m_Request.Reserve.Del(delResv);
    }
}
