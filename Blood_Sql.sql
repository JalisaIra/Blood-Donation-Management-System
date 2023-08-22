create database BloodTransfusion
use BloodTransfusion
--complete task 1
create table Admin(
Admin_Id int primary key identity(1,1),
Name Varchar(50) Not Null,
Address Varchar(50) Not Null,
Email Varchar(40) Not Null,
PhoneNumber Varchar(20) Not Null,
Password Varchar(20) Not Null
)
insert into Admin values ('paul', 'dhaka','ssss','01970307986','12345'),
('ira', 'dhaka','ssss','01970307986','11111'),
('era', 'dhaka','ssss','01970307986','22222')
select * from Admin

--complete task 2
create table Donor_Bio_Details(
Donor_Id int primary key identity(1001,1),
Name Varchar(50) Not Null,
FatherName varchar(30)not null,
MotherName varchar(30) not null,
DOB varchar (12) not null,
MobileNo varchar (11) not null,
Gender varchar (14) not null,
Availability_ varchar(14) not null,
email varchar(50) not null,
BloodGroup varchar(12) not null,
City varchar(20) not null,
address_ varchar (50) not null,
PreviousDisease Varchar(50) Not Null
)
--drop table Donor_Bio_Details 
select * from Donor_Bio_Details


SELECT CONVERT(DATE,DOB,103) from Donor_Bio_Details

GO create view [Donor] AS select Donor_Id,CONVERT(DATE,DOB,103) as DDOB from Donor_Bio_Details GO
select * from Donor

--age+ info
select Donor_Bio_Details.Donor_Id,Name,DOB,b.Age,MobileNo,Gender, email,BloodGroup,address_ ,Patient_Id,PatientName,Donation_Category,Donation_Date,days,
case when days > 90 then 'Donor Available'
else 'Donor Not Available'
end as Status from Donor_Bio_Details join (select Donor_Id,Donation_Category,Donation_Date,DATEDIFF(day, Donation_Date, GETDATE()) AS days from Donor_DonationDetail) 
as a on  Donor_Bio_Details.Donor_Id=a.Donor_Id join (select Donor_Id, DATEDIFF(YEAR, DDOB, GETDATE()) AS Age from Donor ) as b
on Donor_Bio_Details.Donor_Id=b.Donor_Id join (select Donor_Id,Patient_Id,PatientName from Donated_patients group by Patient_Id,PatientName,Donor_Id) as c on Donor_Bio_Details.Donor_Id=c.Donor_Id 

--Appointments available donor for Today
select Donor_Bio_Details.Donor_Id,Name,MobileNo,BloodGroup,address_ ,Donation_Date,days,days1,
case when days > 90 or days1> 90 then 'Donor Available'
else 'Donor Not Available'
end as Status from Donor_Bio_Details join (select Donor_Id,Donation_Category,Donation_Date,DATEDIFF(day, Donation_Date, GETDATE()) AS days, DATEDIFF(day, GETDATE(),Donation_Date) AS days1 from Donor_DonationDetail) 
as a on  Donor_Bio_Details.Donor_Id=a.Donor_Id 

--to find who is available for appointment
select Donor_Bio_Details.Donor_Id,Name,MobileNo,BloodGroup,address_ ,Donation_Date,days,days1,
case when days > 90 or days1> 90 then 'Donor Available'
else 'Donor Not Available'
end as Status from Donor_Bio_Details join (select Donor_Id,Donation_Category,Donation_Date,DATEDIFF(day, Donation_Date, '2023-10-24') AS days, DATEDIFF(day, '2023-10-24',Donation_Date) AS days1 from Donor_DonationDetail) 
as a on  Donor_Bio_Details.Donor_Id=a.Donor_Id 

--- select Donation_Id,Donation_Category, BloodGroup,TotalAmount from CategoryDonation_Detail where CollectionDate = (select CONVERT(DATE,GETDATE(),103))");
            


 --group by Donation_Category,Donation_Date,Donor_Id 
GO create view [Donor1] AS select Donor_Id,max(Donation_Date) as Donation_date from Donor_DonationDetail group by Donor_Id GO
select * from Donor1
--where Donor_Bio_Details.Donor_Id=1001

--3rd task complete
create table DonorBloodDetail(
Donor_Id int not null foreign key references Donor_Bio_Details(Donor_Id),
Blood_Details_Id int primary key identity(1,1),
Albumin int Not Null,
Globulin int Not Null,
Fibrinogen int Not Null,
WhiteBloodCell Varchar(20) Not Null,
RedBloodSell Varchar(20) Not Null,
Platelets Varchar(20) Not Null,
Potassium Varchar(20) Not Null,
Sodium varchar(20) not null,
BloodPressure Varchar(20) Not Null
)

select * from DonorBloodDetail
--for plasma
select Donor_Bio_Details.Donor_Id,Name,FatherName,MotherName,DOB,MobileNo,Gender, email,BloodGroup,address_ ,PreviousDisease,sample.Plasma,days,Donation_Category,
case when days > 30 then 'Donor Available'
else 'Donor Not Available'
end as AA  from Donor_Bio_Details join  
(select Donor_Id,sum(Albumin+Globulin+Fibrinogen) as Plasma from DonorBloodDetail group by Donor_Id) as sample
on Donor_Bio_Details.Donor_Id=sample.Donor_Id
inner join (select Donor_Id,Donation_Category,DATEDIFF(day, Donation_Date, GETDATE()) AS days from Donor_DonationDetail where Donation_Category ='Plasma') 
as a on  Donor_Bio_Details.Donor_Id=a.Donor_Id 
where Plasma between 60 and 100

--for platelet
select Donor_Bio_Details.Donor_Id,Name,FatherName,MotherName,DOB,MobileNo,Gender, email,BloodGroup,address_ ,PreviousDisease,sample.Platelets,days,Donation_Category,
case when days > 90 then 'Donor Available'
else 'Donor Not Available'
end as AA  from Donor_Bio_Details join 
(select Donor_Id,Platelets from DonorBloodDetail where Platelets between '150000' and '400000' group by Platelets,Donor_Id) as sample
on Donor_Bio_Details.Donor_Id=sample.Donor_Id
inner join (select Donor_Id,Donation_Category,DATEDIFF(day, Donation_Date, GETDATE()) AS days from Donor_DonationDetail where Donation_Category ='Platelet') 
as a on  Donor_Bio_Details.Donor_Id=a.Donor_Id 
order by Donor_Id


--drop table DonorBloodDetails
--4th task complete
create table Donation_Category(DonationCategory_Id int primary key identity(1,1),
Donation_Category Varchar(20) Not Null
)insert into Donation_Category values ('Blood Donation'),
                                     ('Plasma Donation'),
									 ('Platelests Donation')
select * from Donation_Category

--5th task complete run dsi
create table Donor_DonationDetail(
D_Donation_DetailsId int primary key identity(1,1),
Donor_Id int not null foreign key references Donor_Bio_Details(Donor_Id),
Donation_Date Date Not Null,
Donation_Category Varchar(50) Not Null,
DonationAmount Varchar(50) Not Null
)

select * from Donor_DonationDetail

delete from Donor_DonationDetail where D_Donation_DetailsId=6

TRUNCATE TABLE Donor_DonationDetail

--drop table DonorDonationDetail

--6th task complete
create table CategoryDonation_Detail(
Donation_Id int primary key identity(1,1),
DonationCategory_Id int not null foreign key references Donation_Category(DonationCategory_Id),
Donation_Category Varchar(50) Not Null,
BloodGroup Varchar(50) Not Null,
CollectionDate date Not Null,
FrizzingTemperature Varchar(50) Not Null,
TotalAmount Int Not Null check(TotalAmount>-1)
)
select * from CategoryDonation_Detail where CollectionDate = (select CONVERT(DATE,GETDATE(),103))

--on process......Done total stcok show
go create view [Total] as select  Donation_Category,BloodGroup,sum(TotalAmount) as Total from CategoryDonation_Detail group by BloodGroup, Donation_Category  go
select * from Total

select DATEDIFF(day,  CollectionDate,GETDATE()) AS days from CategoryDonation_Detail

--Donated Sample Expiration
select Donation_Category.DonationCategory_Id,Donation_Category,a.BloodGroup,CollectionDate,a.FrizzingTemperature,a.TotalAmount,days, case when days > 60 then 'Expired'
when days = 60 then 'Expired'
else 'Freshly Resevered'
end as Status  from Donation_Category join (select DonationCategory_Id,BloodGroup,CollectionDate,FrizzingTemperature,TotalAmount,DATEDIFF(day, CollectionDate, GETDATE()) AS days
from CategoryDonation_Detail) as a on  Donation_Category.DonationCategory_Id=a.DonationCategory_Id order by DonationCategory_Id 

TRUNCATE TABLE CategoryDonation_Details
--drop table CategoryDonation_Details
--7th task
create table Donated_patients(
Patient_Id int primary key identity(6001,1),
Donor_Id int not null foreign key references Donor_Bio_Details(Donor_Id),
PatientName Varchar(50) Not Null,
Disease Varchar(50) Not Null,
ObtainedDonationType Varchar(50) Not Null
)

select * from Donated_patients

--drop table Donated_patients

create table Appointments_1(
Appointment_Id int primary key identity(5001,1),
Donor_Id int not null foreign key references Donor_Bio_Details(Donor_Id),
Name Varchar(50) Not Null,
Appointment_Date Date Not Null,
MobileNo varchar (11) not null,
Gender varchar (14) not null,
Donation_Category Varchar(50) Not Null,
BloodGroup varchar(12) not null,
address_ varchar (600) not null,
Disease Varchar(50) Not Null,
Amount Varchar(100) Not Null
)
select * from Appointments_1

create table Reservations(
Reservation_Id int primary key identity(1,1),
Donor_Id int not null foreign key references Donor_Bio_Details(Donor_Id),
Name Varchar(50) Not Null,
Reservation_Date Date Not Null,
MobileNo varchar (11) not null,
Gender varchar (14) not null,
Donation_Category Varchar(50) Not Null,
BloodGroup varchar(12) not null,
address_ varchar (600) not null,
Disease Varchar(50) Not Null,
Amount Varchar(100) Not Null
)
select * from Reservations

--Appointments available donor
select Donor_Bio_Details.Donor_Id,Name,MobileNo,BloodGroup,address_ ,Donation_Date,days,days1,
case when days > 90 or days1> 90 then 'Donor Available'
else 'Donor Not Available'
end as Status from Donor_Bio_Details join (select Donor_Id,Donation_Category,Donation_Date,DATEDIFF(day, Donation_Date, GETDATE()) AS days, DATEDIFF(day, GETDATE(),Donation_Date) AS days1 from Donor_DonationDetail) 
as a on  Donor_Bio_Details.Donor_Id=a.Donor_Id 

--to find who is available for appointment
select Donor_Bio_Details.Donor_Id,Name,MobileNo,BloodGroup,address_ ,Donation_Date,days,days1,
case when days > 90 or days1> 90 then 'Donor Available'
else 'Donor Not Available'
end as Status from Donor_Bio_Details join (select Donor_Id,Donation_Category,Donation_Date,DATEDIFF(day, Donation_Date, '2023-10-24') AS days, DATEDIFF(day, '2023-10-24',Donation_Date) AS days1 from Donor_DonationDetail) 
as a on  Donor_Bio_Details.Donor_Id=a.Donor_Id 

go create view [q2] as select Donor_Bio_Details.Donor_Id,Name,MobileNo,BloodGroup,address_ ,Donation_Date,days,days1,
case when days > 90 or days1> 90 then 'Donor Available'
else 'Donor Not Available'
end as Status from Donor_Bio_Details join (select Donor_Id,Donation_Category,Donation_Date,DATEDIFF(day, Donation_Date, '2023-10-24') AS days, DATEDIFF(day, '2023-10-24',Donation_Date) AS days1 from Donor_DonationDetail) 
as a on  Donor_Bio_Details.Donor_Id=a.Donor_Id  go
 
select * from q2

select top 1 DATEDIFF(day,Donation_Date,GETDATE()) AS days from Donor_DonationDetail where Donor_Id= 1001 order by Donation_Date desc