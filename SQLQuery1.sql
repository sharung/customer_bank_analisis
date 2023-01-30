
with customer_data as ( -- membuat CTE untuk customer_data
SELECT [CLIENTNUM]
      ,[idstatus] = status -- menampilkan nama status berdasarkan no id
      ,[Customer_Age]
      ,[Gender]
      ,[Dependent_count]
      ,[Educationid] = education_level -- menampilkan nama education_level berdasarkan no id
      ,[Maritalid] = marital_status -- menampilkan nama marital_status berdasarkan no id
      ,[Income_Category]
      ,[card_categoryid] = card_category -- menampilkan nama card_category berdasarkan no id
      ,[Months_on_book]
      ,[Total_Relationship_Count]
      ,[Months_Inactive_12_mon]
      ,[Contacts_Count_12_mon]
      ,[Credit_Limit]
      ,[Total_Revolving_Bal]
      ,[Avg_Open_To_Buy]
      ,[Total_Trans_Amt]
      ,[Total_Trans_Ct]
      ,[Avg_Utilization_Ratio]
  FROM [customer_data_history] cd
  left join category_db c on c.id = cd.card_categoryid -- untuk menggabungkan category_db dengan customer_data_history
  left join education_db e on e.id = cd.Educationid -- untuk menggabungkan education_db dengan customer_data_history
  left join marital_db m on m.id = cd.Maritalid -- untuk menggabungkan marital_db dengan customer_data_history
  left join status_db s on s.id = cd.idstatus -- untuk menggabungkan status_db dengan customer_data_history
  where Total_Revolving_Bal > 0 and Avg_Utilization_Ratio > 0
)
,data_customer_fix as ( -- membuat CTE untuk customer_data
SELECT [CLIENTNUM]
      ,[idstatus] = status -- menampilkan nama status berdasarkan no id
      ,[Customer_Age]
      ,[Gender]
      ,[Dependent_count]
      ,[Educationid] = education_level -- menampilkan nama education_level berdasarkan no id
      ,[Maritalid] = marital_status -- menampilkan nama marital_status berdasarkan no id
      ,[Income_Category]
      ,[card_categoryid] = card_category -- menampilkan nama card_category berdasarkan no id
      ,[Months_on_book]
      ,[Total_Relationship_Count]
      ,[Months_Inactive_12_mon]
      ,[Contacts_Count_12_mon]
      ,[Credit_Limit]
      ,[Total_Revolving_Bal]
      ,[Avg_Open_To_Buy]
      ,[Total_Trans_Amt]
      ,[Total_Trans_Ct]
      ,[Avg_Utilization_Ratio]
  FROM [customer_data_history] cd
  left join category_db c on c.id = cd.card_categoryid -- untuk menggabungkan category_db dengan customer_data_history
  left join education_db e on e.id = cd.Educationid -- untuk menggabungkan education_db dengan customer_data_history
  left join marital_db m on m.id = cd.Maritalid -- untuk menggabungkan marital_db dengan customer_data_history
  left join status_db s on s.id = cd.idstatus -- untuk menggabungkan status_db dengan customer_data_history
  where Total_Revolving_Bal > 0 and Avg_Utilization_Ratio > 0
)
select * 
into #data_customer_fix -- membuat table baru bernama #data_customer dengan mengcopy table customer_data 
from customer_data

select * from #data_customer_fix

-- profile customer
select CLIENTNUM,idstatus, Customer_Age, Gender, Educationid, Maritalid, Income_Category from #data_customer_fix

-- Retention Rate dari customer aktive untuk mengetahui tingkat retensi customer yang menggunakan layanan kartu kredit
select Months_on_book, Months_Inactive_12_mon from #data_customer_fix
where idstatus like 'Existing Customer'

-- Utilisasi kartu kredit untuk mengetahui seberapa banyak customer menggunakan kartu kredit mereka dan tingkat utilisasi kartu kredit
select Credit_limit, Total_Revolving_Bal, Avg_open_to_buy, Avg_utilization_ratio from #data_customer_fix

-- Frekuensi transaksi mengetahui frekuensi transaksi yang dilakukan oleh customer dan jumlah transaksi yang dilakukan
select Total_Trans_Amt,Total_Trans_Ct from #data_customer_fix

-- Segmentasi customer untuk mengelompokkan customer berdasarkan jenis kartu kredit yang digunakan, jumlah produk yang dimiliki, frekuensi dihubungi bank dan kategori layanan kartu kredit
select Card_categoryid,Total_Relationship_Count,Contacts_Count_12_mon from #data_customer_fix

-- Identifikasi customer dengan risiko tinggi untuk mengidentifikasi customer yang memiliki risiko tinggi dalam hal keterlambatan pembayaran atau kehilangan customer
select idstatus, Contacts_Count_12_mon, Months_Inactive_12_mon from #data_customer_fix

--Pertumbuhan penghasilan untuk mengetahui tingkat pertumbuhan penghasilan customer dari waktu ke waktu.
select CLIENTNUM ,Income_Category from #data_customer_fix

-- Identifikasi customer yang terlambat membayar untuk mengidentifikasi customer yang terlambat dalam membayar tunggakan kartu kreditnya.
select clientnum,idstatus, Contacts_Count_12_mon from #data_customer_fix





-- penyebab utang perhitungan gender cewe
select idstatus, customer_age, count(case when gender='M' then gender end) as male from customer_data_fix
where lower(idstatus) = 'attrited customer'
group by idstatus, customer_age

-- perhitungan F 
select idstatus, Customer_Age, count(case when gender='f' then gender end) from customer_data_fix
where idstatus = 'attrited customer'
group by idstatus, Customer_Age

-- income customer
select Income_Category, count(Income_Category) from customer_data_fix
where idstatus = 'attrited customer'
group by Income_Category








