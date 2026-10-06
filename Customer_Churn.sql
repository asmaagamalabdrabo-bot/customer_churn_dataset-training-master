create database customer_churn

use customer_churn;

--Basic Analysis
--إجمالي عدد العملاء

SELECT COUNT(*) AS Total_Customers
FROM [churn_clean (3)];

--متوسط عمر العملاء
SELECT ROUND(AVG(Age), 2) AS Average_Age
FROM [churn_clean (3)];


-- توزيع العملاء حسب النوع
--عدد العلاء الذكور و الاناث
SELECT 
    Gender,
    COUNT(*) AS Customer_Count
FROM [churn_clean (3)]
GROUP BY Gender
ORDER BY Customer_Count DESC;


-- توزيع العملاء حسب نوع الاشتراك
-- عدد العملاء في كل نوع من انواع الاشتراك
SELECT 
    [subscription_type],
    COUNT(*) AS Customer_Count
FROM [churn_clean (3)]
GROUP BY [subscription_type]
ORDER BY Customer_Count DESC;

-- عدد العملاء الذين غادرو الخدمة وعدد العملاء الذين استمرو
SELECT 
    Churn,
    COUNT(*) AS Customer_Count
FROM [churn_clean (3)]
GROUP BY Churn;

-- نسبة العلاء الذين غادرو الخدمة
SELECT 
    CAST(
        100.0 * SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) / COUNT(*)
        AS DECIMAL(5,2)
    ) AS Churn_Rate
FROM [churn_clean (3)];

-- Churn Analysis
-- هل نوع الاشتراك مرتبط باختلاف معدل مغادرة العملاء
SELECT 
    [Subscription_Type],
    COUNT(*) AS Total_Customers,
    SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) AS Churned_Customers,
    CAST(
        100.0 * SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) / COUNT(*)
        AS DECIMAL(5,2)
    ) AS Churn_Rate
FROM [churn_clean (3)]
GROUP BY [Subscription_Type]
ORDER BY Churn_Rate DESC;

-- أي مدة عقد لديها أعلى معدل مغادرة
SELECT 
    [Contract_Length],
    COUNT(*) AS Total_Customers,
    SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) AS Churned_Customers,
    CAST(
        100.0 * SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) / COUNT(*)
        AS DECIMAL(5,2)
    ) AS Churn_Rate
FROM [churn_clean (3)]
GROUP BY [Contract_Length]
ORDER BY Churn_Rate DESC;

-- churn هل زيادة عدد مكالمات خدمة العملاء مرتبطة بزيادة ال  
SELECT 
    Churn,
    ROUND(AVG([support_calls]), 2) AS Average_Support_Calls
FROM [churn_clean (3)]
GROUP BY Churn;

--هل يوجد ارتباط بين تأخير الدفع ومغادرة العملاء؟
SELECT 
    Churn,
    ROUND(AVG([payment_delay]), 2) AS Average_Payment_Delay
FROM [churn_clean (3)]
GROUP BY Churn;

-- مدة اشتراك العميل وهل العلاء الاقدم لديهم معدل مغادرة اقل
SELECT 
    Churn,
    ROUND(AVG(Tenure), 2) AS Average_Tenure
FROM [churn_clean (3)]
GROUP BY Churn;

-- هل العملاء الذين ينفقون أكثر أقل عرضة لمغادرة الخدمة؟
SELECT 
    Churn,
    CAST(AVG([total_spend]) AS DECIMAL(10,2)) AS Average_Total_Spend
FROM [churn_clean (3)]
GROUP BY Churn;

--هل يوجد فرق في معدل المغادرة بين الذكور والإناث؟
SELECT 
    Gender,
    COUNT(*) AS Total_Customers,
    SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) AS Churned_Customers,
    CAST(
        100.0 * SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) / COUNT(*)
        AS DECIMAL(5,2)
    ) AS Churn_Rate
FROM [churn_clean (3)]
GROUP BY Gender
ORDER BY Churn_Rate DESC

--هل العملاء الذين مر وقت أطول منذ آخر تفاعل أكثر عرضة للمغادرة؟
SELECT 
    Churn,
    CAST(AVG([last_interaction]) AS DECIMAL(10,2)) AS Average_Last_Interaction
FROM [churn_clean (3)]
GROUP BY Churn;

--Customer Profile
-- ما الفرق في خصائص العملاء الذين غادروا مقارنة بالعملاء الذين استمرو
SELECT
    Churn,
    CAST(AVG(Age) AS DECIMAL(10,2)) AS Average_Age,
    CAST(AVG(Tenure) AS DECIMAL(10,2)) AS Average_Tenure,
    CAST(AVG([usage_frequency]) AS DECIMAL(10,2)) AS Average_Usage,
    CAST(AVG([support_calls]) AS DECIMAL(10,2)) AS Average_Support_Calls,
    CAST(AVG([payment_delay]) AS DECIMAL(10,2)) AS Average_Payment_Delay,
    CAST(AVG([total_spend]) AS DECIMAL(10,2)) AS Average_Total_Spend
FROM [churn_clean (3)]
GROUP BY Churn;

--Business Analysis
-- ما نسبة إجمالي إنفاق العملاء الذين غادروا من إجمالي إنفاق جميع العملاء؟
SELECT
    CAST(
        100.0 *
        SUM(CASE WHEN Churn = 1 THEN [total_spend] ELSE 0 END)
        / SUM([total_spend])
        AS DECIMAL(5,2)
    ) AS Churned_Spend_Percentage
FROM [churn_clean (3)];

-- أخطر شرائح العملاء
-- ما الشرائح التي لديها اعلي نسبة مغادرة
SELECT
    [subscription_type],
    [contract_length],
    COUNT(*) AS Total_Customers,
    SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) AS Churned_Customers,
    CAST(
        100.0 *
        SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END)
        / COUNT(*)
        AS DECIMAL(5,2)
    ) AS Churn_Rate
FROM [churn_clean (3)]
GROUP BY
    [subscription_type],
    [contract_length]
ORDER BY Churn_Rate DESC;

--تقسيم العملاء الي مستويات خطر
SELECT
    customer_id,
    Age,
    Tenure,
    [support_calls],
    [payment_delay],
    [last_interaction],
    Churn,
    CASE
        WHEN [support_calls] >= 8 
             AND [payment_delay] >= 15
            THEN 'High Risk'

        WHEN [support_calls] >= 5 
             OR [payment_delay] >= 10
            THEN 'Medium Risk'
        ELSE 'Low Risk'
    END AS Risk_Level
FROM [churn_clean (3)];

--عدد العملاء في كل مستوي من مستويات الخطر
SELECT
    CASE
        WHEN [support_calls] >= 8 
             AND [payment_delay] >= 15
            THEN 'High Risk'
        WHEN [support_calls] >= 5 
             OR [payment_delay] >= 10
            THEN 'Medium Risk'
        ELSE 'Low Risk'
    END AS Risk_Level,
    COUNT(*) AS Customer_Count
FROM [churn_clean (3)]
GROUP BY
    CASE
        WHEN [support_calls] >= 8 
             AND [payment_delay] >= 15
            THEN 'High Risk'
        WHEN [support_calls] >= 5 
             OR [payment_delay] >= 10
            THEN 'Medium Risk'
        ELSE 'Low Risk'
    END
ORDER BY Customer_Count DESC;