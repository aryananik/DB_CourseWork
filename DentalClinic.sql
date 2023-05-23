CREATE SCHEMA IF NOT EXISTS `dentalclinic` DEFAULT CHARACTER SET utf8 ;
USE `dentalclinic` ;

-- -----------------------------------------------------
-- Table `dentalclinic`.`Specialization`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `dentalclinic`.`Specialization` (
  `Specialization` VARCHAR(45) NOT NULL,
  `Salary` INT NOT NULL,
  PRIMARY KEY (`Specialization`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `dentalclinic`.`Doctor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `dentalclinic`.`Doctor` (
  `idDoctor` INT NOT NULL,
  `Name` VARCHAR(45) NOT NULL,
  `Specialization` VARCHAR(45) NOT NULL,
  `Age` INT NOT NULL,
  PRIMARY KEY (`idDoctor`, `Specialization`),
  INDEX `fk_Doctor_Specialization1_idx` (`Specialization` ASC) VISIBLE,
  CONSTRAINT `fk_Doctor_Specialization1`
    FOREIGN KEY (`Specialization`)
    REFERENCES `dentalclinic`.`Specialization` (`Specialization`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `dentalclinic`.`PersonalInfo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `dentalclinic`.`PersonalInfo` (
  `id` INT NOT NULL,
  `Passport` INT NOT NULL,
  `Polis` INT NOT NULL,
  `Addres` VARCHAR(45) NOT NULL,
  `Phonenumber` INT NOT NULL,
  `Age` INT NOT NULL,
  `Gender` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `dentalclinic`.`Patient`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `dentalclinic`.`Patient` (
  `idPatient` INT NOT NULL,
  `Name` VARCHAR(45) NOT NULL,
  `pi_id` INT NOT NULL,
  PRIMARY KEY (`idPatient`, `pi_id`),
  INDEX `fk_Patient_MedicalCard1_idx` (`pi_id` ASC) VISIBLE,
  CONSTRAINT `fk_Patient_MedicalCard1`
    FOREIGN KEY (`pi_id`)
    REFERENCES `dentalclinic`.`PersonalInfo` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `dentalclinic`.`Diagnosis`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `dentalclinic`.`Diagnosis` (
  `idDiagnosis` INT NOT NULL,
  `Diagnosis` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idDiagnosis`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `dentalclinic`.`Appointment`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `dentalclinic`.`Appointment` (
  `AppointmentID` INT NOT NULL,
  `Date` DATE NOT NULL,
  `Time` TIME NOT NULL,
  `idDoctor` INT NOT NULL,
  `idPatient` INT NOT NULL,
  `idDiagnosis` INT NOT NULL,
  PRIMARY KEY (`AppointmentID`, `idDoctor`, `idPatient`, `idDiagnosis`),
  INDEX `fk_Doctor_has_Patient_Patient1_idx` (`idPatient` ASC) VISIBLE,
  INDEX `fk_Doctor_has_Patient_Doctor1_idx` (`idDoctor` ASC) VISIBLE,
  INDEX `fk_Appointment_Diagnosis1_idx` (`idDiagnosis` ASC) VISIBLE,
  CONSTRAINT `fk_Doctor_has_Patient_Doctor1`
    FOREIGN KEY (`idDoctor`)
    REFERENCES `dentalclinic`.`Doctor` (`idDoctor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Doctor_has_Patient_Patient1`
    FOREIGN KEY (`idPatient`)
    REFERENCES `dentalclinic`.`Patient` (`idPatient`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Appointment_Diagnosis1`
    FOREIGN KEY (`idDiagnosis`)
    REFERENCES `dentalclinic`.`Diagnosis` (`idDiagnosis`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `dentalclinic`.`Treatment`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `dentalclinic`.`Treatment` (
  `idTreatment` INT NOT NULL AUTO_INCREMENT,
  `Treatment` VARCHAR(45) NOT NULL,
  `Price` INT NOT NULL,
  PRIMARY KEY (`idTreatment`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `dentalclinic`.`Assistent`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `dentalclinic`.`Assistent` (
  `idAssistent` INT NOT NULL,
  `Name` VARCHAR(45) NULL,
  `Age` INT NULL,
  `Salary` INT NULL,
  PRIMARY KEY (`idAssistent`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `dentalclinic`.`DoctorAssistent`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `dentalclinic`.`DoctorAssistent` (
  `Doctor_idDoctor` INT NOT NULL,
  `Assistent_idAssistent` INT NOT NULL,
  PRIMARY KEY (`Doctor_idDoctor`, `Assistent_idAssistent`),
  INDEX `fk_Assistent_has_Doctor_Doctor1_idx` (`Doctor_idDoctor` ASC) VISIBLE,
  INDEX `fk_Assistent_has_Doctor_Assistent1_idx` (`Assistent_idAssistent` ASC) VISIBLE,
  CONSTRAINT `fk_Assistent_has_Doctor_Assistent1`
    FOREIGN KEY (`Assistent_idAssistent`)
    REFERENCES `dentalclinic`.`Assistent` (`idAssistent`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Assistent_has_Doctor_Doctor1`
    FOREIGN KEY (`Doctor_idDoctor`)
    REFERENCES `dentalclinic`.`Doctor` (`idDoctor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `dentalclinic`.`SterilizationDuty`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `dentalclinic`.`SterilizationDuty` (
  `Day` VARCHAR(45) NOT NULL,
  `NumberOfToolsSterilized` INT NOT NULL,
  `ToolsToThrow` INT NOT NULL,
  PRIMARY KEY (`Day`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `dentalclinic`.`AppointmentTreatment`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `dentalclinic`.`AppointmentTreatment` (
  `AppointmentID` INT NOT NULL,
  `idTreatment` INT NOT NULL,
  PRIMARY KEY (`AppointmentID`, `idTreatment`),
  INDEX `fk_Treatment_has_Appointment_Appointment1_idx` (`AppointmentID` ASC) VISIBLE,
  INDEX `fk_Treatment_has_Appointment_Treatment1_idx` (`idTreatment` ASC) VISIBLE,
  CONSTRAINT `fk_Treatment_has_Appointment_Treatment1`
    FOREIGN KEY (`idTreatment`)
    REFERENCES `dentalclinic`.`Treatment` (`idTreatment`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Treatment_has_Appointment_Appointment1`
    FOREIGN KEY (`AppointmentID`)
    REFERENCES `dentalclinic`.`Appointment` (`AppointmentID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `dentalclinic`.`AssistentSterilizationDuty`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `dentalclinic`.`AssistentSterilizationDuty` (
  `idAssistent` INT NOT NULL,
  `Day` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idAssistent`, `Day`),
  INDEX `fk_Assistent_has_SterilizationDuty_SterilizationDuty1_idx` (`Day` ASC) VISIBLE,
  INDEX `fk_Assistent_has_SterilizationDuty_Assistent1_idx` (`idAssistent` ASC) VISIBLE,
  CONSTRAINT `fk_Assistent_has_SterilizationDuty_Assistent1`
    FOREIGN KEY (`idAssistent`)
    REFERENCES `dentalclinic`.`Assistent` (`idAssistent`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Assistent_has_SterilizationDuty_SterilizationDuty1`
    FOREIGN KEY (`Day`)
    REFERENCES `dentalclinic`.`SterilizationDuty` (`Day`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

use dentalclinic;
INSERT doctor(idDoctor, Name, Specialization, Age) 
VALUES
(1, 'Иванов М.Н.', 'Ортодонт', 38),
(2, 'Петрова А.В.', 'Терапевт', 27),
(3, 'Никифоров Д.А.', 'Хирург', 30),
(4, 'Самойлов Ф.П.', 'Ортопед', 32),
(5, 'Кузнецова М.А.', 'Ортодонт', 42),
(6, 'Иванова Н.В', 'Хирург', 36);

insert specialization(Specialization, Salary)
values
('Ортодонт',80000),
('Терапевт',50000),
('Хирург',125000),
('Ортопед',70000);

INSERT assistent(idAssistent, Name, Age, Salary)
VALUES
(1, 'Щербаков С.Г', 46, 40000),
(2, 'Доржиев А.М.', 32, 45000),
(3, 'Никифорова М.М.', 25, 35000);

INSERT sterilizationduty(Day, NumberOfToolsSterilized, ToolsToThrow)
VALUES
('Пн', 25, 3),
('Вт', 10, 0),
('Ср', 13, 1),
('Чт', 8, 4),
('Пт', 10, 0),
('Сб', 21, 6),
('Вс', 11, 4);

INSERT patient(idPatient, Name, pi_id)
VALUES
(1, 'Высоцкий С.В.', 1011),
(2, 'Бурова Д.Д.', 1801),
(3, 'Герасимова А.М', 1225),
(4, 'Миронов В.М.', 1105),
(5, 'Петров А.А.', 1022),
(6, 'Дондукова В.В.', 1012),
(7, 'Игумнов Д.М.', 3001),
(8, 'Цырендоржиева А.С.', 2031),
(9, 'Мохначева М.А.', 1326),
(10, 'Сидоров Е.Ф.', 1919);

ALTER TABLE PersonalInfo
ADD PassportNum INT NOT NULL;
ALTER TABLE PersonalInfo
MODIFY COLUMN Phonenumber CHAR(11) NOT NULL;
INSERT PersonalInfo(id, Passport, PassportNum, Polis, Addres, Phonenumber, Age, Gender)
VALUES
(1011, 8103, 125698, 101202, 'ул.Правды,17 кв.1', 88005553535, 20, 'м'),
(1801, 8103, 201151, 102313, 'ул.Фестивальная,14 кв.125', 88015553535, 28, 'ж'),
(1225, 8105, 101121, 102516, 'ул.Кабанская,20 кв.87', 88005558524, 32, 'ж'),
(1105, 8102, 704028, 101605, 'ул.Шмидта,17 кв.6', 88009997979, 31, 'м'),
(1022, 8101, 801806, 110208, 'ул.Шмидта,18 кв.5', 88005550011, 18, 'м'),
(1012, 8117, 902901, 108888, 'ул.Ермакова,1 кв.3', 88505556565, 65, 'ж'),
(3001, 8116, 201202, 109890, 'ул.Кабанская,16 кв.32', 88002223535, 48, 'м'),
(2031, 8001, 205149, 110761, 'ул.Обручева,3 кв.21', 88005556677, 36, 'ж'),
(1326, 8117, 103778, 106003, 'ул.Никольская,10 кв.9', 88005657799, 23, 'ж'),
(1919, 8203, 109026, 112012, 'ул.Солянка,7 кв.2', 88645342202, 47, 'м');
select * from PersonalInfo;

INSERT diagnosis(idDiagnosis, Diagnosis)
VALUES
(1, 'Кариес'),
(2, 'Пульпит'),
(3, 'Периодонтит'),
(4, 'Парадонтит'),
(5, 'Гингивит'),
(6, 'Скученность зубов'),
(7, 'Аномалия числа зубов'),
(8, 'Аномалия прикуса'),
(9, 'Новообразования в тканях'),
(10, 'Эстетическая нужда'),
(11, 'Импланты');

INSERT treatment(idTreatment, Treatment, Price)
VALUES
(1, 'Чистка зубов', 5000),
(2, 'Отбеливание', 8000),
(3, 'Реставрация', 25000),
(4, 'Удаление экзостаза', 10000),
(5, 'Удаление зуба', 3000),
(6, 'Удаление зуба мудрости', 8500),
(7, 'Съемные протезы', 50000),
(8, 'Лечение кариеса', 1000),
(9, 'Лечение пульпита', 2500),
(10, 'Лечение парадонтита', 3500),
(11, 'Лечение гингивита', 6000),
(12, 'Брекеты', 60000),
(13, 'Импланты', 150000),
(14, 'Первичный прием', 700),
(15, 'Пластинка', 3000);

INSERT DoctorAssistent(Doctor_idDoctor, Assistent_idAssistent)
VALUES
(1, 1),
(2, 2),
(3, 3),
(3, 2),
(4, 1),
(5, 2),
(6, 3);
select * from appointment;
INSERT appointment(AppointmentID, Date, Time, idDoctor,idPatient, idDiagnosis)
VALUES
(102, '2022-10-12', '10:30', 6, 10, 5),
(103, '2022-10-12', '10:30', 1, 6, 6),
(104, '2022-10-30', '9:45', 2, 7, 1),
(105, '2022-11-01', '15:00', 4, 9, 8);
INSERT AppointmentTreatment(AppointmentID, idTreatment)
VALUES
(101, 13),
(102, 11),
(103, 12),
(104, 8),
(105, 15);
use dentalclinic;
/*ЗАПРОСЫ*/
/* 1. Информация о приеме */
select my.id, Date, Time, Doctor.Name as 'Doctor', Patient.Name as 'Patient', Diagnosis.Diagnosis as Diagnosis,
my.Price as Bill
from Appointment
    join AppointmentTreatment on AppointmentTreatment.AppointmentID = Appointment.AppointmentID
	join Doctor on Doctor.idDoctor = Appointment.idDoctor
	join Patient on Patient.idPatient = Appointment.idPatient
	join Diagnosis on Diagnosis.idDiagnosis = Appointment.idDiagnosis
    join (select AppointmentTreatment.AppointmentID as id, sum(price) as Price from Treatment
    join AppointmentTreatment on AppointmentTreatment.idTreatment = Treatment.idTreatment
    group by AppointmentTreatment.AppointmentID) as my on my.id = Appointment.AppointmentID
    group by my.id
    having Date = '2022-10-12';

/*2. Вывести ассистентов, проводивших стериллизацию*/
select Assistent.Name as Assistent, SterilizationDuty.Day, NumberOfToolsSterilized as Sterilization, ToolsToThrow as Garbage
from AssistentSterilizationDuty
	right join SterilizationDuty on SterilizationDuty.Day = AssistentSterilizationDuty.Day
    left join Assistent on Assistent.idAssistent = AssistentSterilizationDuty.idAssistent
    order by Name;
    
/* 3. Пациенты женщины*/
select idPatient as id, Name, PersonalInfo.Age from Patient
left join PersonalInfo on PersonalInfo.id = pi_id
where PersonalInfo.Gender = 'ж'
order by Name;

/*представление: врач, специализация, зарплата, количество приемов*/
drop view doctorview;
create view doctorview as
select Name, specialization.Specialization, specialization.salary, count(appointment.idDoctor) as 'Appointments'
from Doctor
join specialization on specialization.Specialization = doctor.Specialization
join appointment on appointment.idDoctor = doctor.idDoctor
group by Name;
select * from doctorview;

/*процедуры и триггеры*/
/*процедура обновления адреса жительства*/
drop procedure updAddres;
DELIMITER $$
create procedure updAddres(pass_ser int, pass_num int, addres varchar(45))
begin
	update PersonalInfo set Addres = addres where Passport = pass_ser and PassportNum = pass_num;
end$$
DELIMITER ;
call updAddres(8203, 109026, 'ул.Свердлова,105 кв.24');
drop procedure updPrice;
DELIMITER $$
create procedure updPrice(tr_name varchar(45), new_price int)
begin
	if tr_name = (select Treatment.Treatment from Treatment where Treatment.Treatment = tr_name) then
		update Treatment set Price = new_price where Treatment.Treatment = tr_name;
	end if;
end$$
 DELIMITER ;
 
 /*procedure вывода личных данных пациента*/
 drop procedure form;
  DELIMITER $$
create procedure form(name varchar (45))
begin 
	declare done int default 0;
	declare id_is int default 0; 
	declare id_p int default 0;
    declare id_pi_is int default 0;
	declare name_p varchar(45) default null;
	declare passser_p int default 0;
	declare passnum_p int default 0;
	declare polis_p int default 0; 
	declare phone_p varchar(11) default null;
	declare age_p int default null;
	declare addres_p varchar (45) default null; 
	declare type_cursor cursor for select Patient.idPatient from Patient;
	declare continue handler for SQLSTATE '02000' set done =1;
	create temporary table aboutpatient (name varchar(45), passport int, passportnum int, polis int, addres varchar(45), 
	phonenumber varchar(11), age int);
    
	set id_is = (select Patient.idPatient from Patient where Patient.Name = name);
	
    open type_cursor;
	repeat
	fetch type_cursor into id_p;
	if not done then
		if id_is=id_p then
		set name_p = name;
        set id_pi_is = (select pi_id from Patient where idPatient = id_p); 
        set passser_p=(select Passport from PersonalInfo where id = id_pi_is);
        set passnum_p=(select PassportNum from PersonalInfo where id = id_pi_is);
        set polis_p=(select Polis from PersonalInfo where id = id_pi_is);
        set addres_p=(select Addres from PersonalInfo where id = id_pi_is);
        set phone_p=(select Phonenumber from PersonalInfo where id = id_pi_is);
		set age_p=(select Age from PersonalInfo where id = id_pi_is);

		insert aboutpatient values (name_p, passser_p, passnum_p, polis_p, addres_p, phone_p, age_p);
		end if;
	end if;
	until done end repeat ;
	close type_cursor;
	select * from aboutpatient;
	drop temporary table aboutpatient;
end$$ 
delimiter ;
call form("Игумнов Д.М.");
/*procedure вставка пациента*/
DELIMITER $$
CREATE PROCEDURE add_patient(id_patient int, patient_name varchar(45),  id_pi int, passport_num int, passport_ser int, polis int, 
addres varchar(45), ph_num varchar(11), age int, gender char)
BEGIN
	if id_pi not in (select id from personalinfo )
	then
		insert into personalinfo values (id_pi, passport_num, polis, addres, ph_num, age, gender, passport_ser);
	end if;
	if not (id_patient in (select idPatient from patient))
	then
		insert into patient values (id_patient, patient_name, id_pi);
	end if;
END$$
DELIMITER ;
drop PROCEDURE add_patient;
call add_patient(11, 'Прусакова Ю.В.', 8010, 8117, 888204, 555000, 'ул.Фестивальная,4 кв.107', 88556649393, 21, 'ж');
drop function age_check;
/*DELIMITER $$
create function age_check(Age int) 
returns INT
deterministic
    begin
    declare ch int;
        if (age < 18) then
			set ch = 0;
            else set ch = 1;
        end if;
        return age;
    end$$

DELIMITER $$
create trigger agecheck before insert on PersonalInfo
for each row 
begin 
declare ch int;
	if (PersonalInfo.Age < 18) then
	signal sqlstate'45000'
    set message_text="underage!";
	end if;
    end $$
    DELIMITER ;
insert into PersonalInfo(id, Passport, PassportNum, Polis, Addres, Phonenumber, Age, Gender)
values(5203, 8116, 239545, 123456, 'vffvbf', 88855585, 16, 'c');
    drop trigger agecheck;
    */
delimiter |
create trigger addtreatment
before insert on treatment
for each row
begin
set new.price=ifnull(new.price,5000);
end|
delimiter ;
insert into treatment(idTreatment,Treatment,Price) values(17,'Удаление нерва',null);
select * from tutor;

    



 