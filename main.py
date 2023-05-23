import mysql.connector as conn
import PySimpleGUI as sg
import re

def connect_with_database():
    try:
        connection = conn.connect(
        host="localhost",
        user="root",
        password="06112002",
        database="DC",
        )
        print("Сonnection with data base established!")
    except conn.Error as e:
        print(e.msg)
        exit(-1)
    return connection

if __name__ == '__main__':
    connect = connect_with_database()
    sg.theme('SystemDefault')

    layoutImage = [[sg.Image(filename = 'image.png', key="-Image-", size = (150, 100))]]  # done

    layoutPatientView = [[sg.Text('Пациенты',font = ('Courier', 15))],[sg.Text('Карточка пациента', font = ('Courier', 13))],
    [sg.Text('ФИО:', font = ('Courier', 10), size=(4, 1),justification='right'), sg.InputText(),sg.Text('                '), sg.Button('Найти',font = ('Courier', 12),size=(15,1))],[sg.Text('             Все пациенты:                                Новый пациент:', size=(100, 1),
                                 justification="left", font=('Courier', 12))],
        [sg.Button('Показать список\nпациентов',font = ('Courier', 12),size=(15,2)),sg.Text("                                                                    "), sg.Button('Добавить пациента',font = ('Courier', 12),size=(15,2))]]# done
    layoutDoctorView = [[sg.Text("Врачи",font=('Courier', 15))],[sg.Text('             Информация о врачах:                         Новый врач:',size =(100, 1),justification="left",font = ('Courier', 12))],
                        [sg.Button('Показать список врачей',size=(15,2),font = ('Courier', 12)),sg.Text("                                                                    "), sg.Button('Добавить врача',font = ('Courier', 12),size=(15,2))]]  # done
    layoutAssistentView = [[sg.Text('             Информация об ассистентах:                   Новый ассистент:', size=(100, 1),
                                 justification="left", font=('Courier', 12))],
                        [sg.Button('Показать список\nассистентов', size=(15, 2), font=('Courier', 12)),
                         sg.Text("                                                                    "),
                         sg.Button('Добавить ассистента', font=('Courier', 12), size=(15, 2))]]  # done

    layoutAppointmentView = [[sg.Text("Приемы",font=('Courier', 15))],[sg.Text('             История приемов:                             Новый прием:',font=('Courier', 12), size =(100, 1),justification="left",)],
                             [sg.Button('Просмотр истории', size = (15,2), font=('Courier', 12)),sg.Text("                                                                    "), sg.Button('Добавить прием', size = (15,2), font=('Courier', 12))]]  # done
    window = sg.Window('Dental Clinic',
                       (layoutImage, layoutPatientView, layoutDoctorView, layoutAssistentView, layoutAppointmentView), size=(900, 700), element_justification='Center')
    # doctor
    curs = connect.cursor()
    event, values = window.read()

    curs.execute("select treatment from treatment;")
    data = curs.fetchall()
    comlist_treat = []
    for i in data:
        s1 = re.sub("[(|'|,|)]", "", str(i))
        comlist_treat.append(s1)

    curs.execute("select name from doctor;")
    data = curs.fetchall()
    comlist_doctor = []
    for i in data:
        s1 = re.sub("[(|'|,|)]", "", str(i))
        comlist_doctor.append(s1)

    curs.execute("select type from typeappointment;")
    data = curs.fetchall()
    comlist_type = []
    for i in data:
        s1 = re.sub("[(|'|,|)]", "", str(i))
        comlist_type.append(s1)

    curs.execute("select diagnosis from diagnosis;")
    data = curs.fetchall()
    comlist_diagnosis = []
    for i in data:
        s1 = re.sub("[(|'|,|)]", "", str(i))
        comlist_diagnosis.append(s1)

    curs.execute("select name from patient;")
    data = curs.fetchall()
    comlist_patient = []
    for i in data:
        s1 = re.sub("[(|'|,|)]", "", str(i))
        comlist_patient.append(s1)
    #print(comlist_patient)
    while True:
        curs = connect.cursor()
        event, values = window.read()
        if event == sg.WIN_CLOSED or event == 'Exit':
            break

        if event == 'Просмотр истории':
            query = "select * from appointment_info"
            curs.execute(query)
            data = curs.fetchall()
            my_data = []
            for i in data:
                my_data.append(list(i))
            print(my_data)
            headings = ['Date', 'Time', 'Doctor', 'Patient', 'Diagnosis', 'Bill']

            layout = [[sg.Text("Date"), sg.InputText(),sg.Button('Search')],[sg.Table(values=my_data, headings=headings, max_col_width=35,
                            auto_size_columns=True,
                            display_row_numbers=True,
                            justification='right',
                            num_rows=20,
                            alternating_row_color='lightblue',
                            key='-TABLE-',
                            row_height=35)]]
            windowView = sg.Window('История приемов', layout)
            eventEntry, valuesEntry = windowView.Read()
            if eventEntry == 'Search':
                result = ''
                if ((str(valuesEntry[0]) != '') & (str(valuesEntry[0]) != 'all')):
                    try:
                        query = "select * from appointment_info where date = '" + str(valuesEntry[0]) + "';"
                        curs.execute(query)
                        data = curs.fetchall()
                        my_data = []
                        for i in data:
                            my_data.append(list(i))
                        print(my_data)


                    except (conn.Error) as error:
                        print()
                        sg.popup("Wrong!", keep_on_top=True)
                elif str(valuesEntry[0]) == 'all':
                    try:
                        query = "select * from appointment_info;"
                        curs.execute(query)
                        data = curs.fetchall()
                        my_data = []
                        for i in data:
                            my_data.append(list(i))
                        print(my_data)


                    except (conn.Error) as error:
                        print()
                        sg.popup("Wrong!", keep_on_top=True)
                windowView.close()
                headings = ['Date', 'Time', 'Doctor', 'Patient', 'Diagnosis', 'Bill']
                layout = [[sg.Text("Date"), sg.InputText(), sg.Button('Search')],
                          [sg.Table(values=my_data, headings=headings, max_col_width=35,
                                    auto_size_columns=True,
                                    display_row_numbers=True,
                                    justification='right',
                                    num_rows=20,
                                    alternating_row_color='lightblue',
                                    key='-TABLE-',
                                    row_height=35)]]
                windowView = sg.Window('История приемов', layout)
            while True:
                eventView, valuesView = windowView.read()
                print(eventView, valuesView)
                if eventView == sg.WIN_CLOSED:
                    break
            windowView.close()
        if event == 'Найти':
            # windowEntry = sg.Window('Окно ввода', layout, keep_on_top=True)
            result = ''
            eventEntry, valuesEntry = window.read()
            while True:
                # eventEntry, valuesEntry = window.Read()
                if eventEntry == 'Найти':
                    # windowEntry.close()
                    if str(valuesEntry[0]) != '':
                        try:
                            param_list = [str(valuesEntry[0])]
                            curs.execute('CALL form(%s);', param_list)
                            data = curs.fetchall()
                            my_data = []
                            for i in data:
                                my_data.append(list(i))
                            print(my_data)
                            if (my_data == []):
                                sg.popup("Нет такого пациента!")
                            headings = ['name', 'passport serie', 'passport number', 'polis', 'addres', 'phone', 'age']

                            layout = [[sg.Table(values=my_data, headings=headings, max_col_width=35,
                                                auto_size_columns=True,
                                                justification='right',
                                                num_rows=20,
                                                alternating_row_color='lightblue',
                                                key='-TABLE-',
                                                row_height=35)]]

                            windowView = sg.Window('The Table Element', layout, size=(1000, 100))

                            while True:
                                eventView, valuesView = windowView.read()
                                print(eventView, valuesView)
                                if eventView == sg.WIN_CLOSED:
                                    break
                            windowView.close()
                        except (conn.Error) as error:
                            print()
                            sg.popup("Wrong!", keep_on_top=True)
                        break
            # curs.close()
        if event == 'Добавить пациента':
            layout = [
                [sg.Text('Пожалуйста, введите необходимые данные.')],
                [sg.Text('имя', size=(15, 1)), sg.InputText()],
                [sg.Text('серия паспорта', size=(15, 1)), sg.InputText()],
                [sg.Text('номер паспорта', size=(15, 1)), sg.InputText()],
                [sg.Text('полис', size=(15, 1)), sg.InputText()],
                [sg.Text('адрес', size=(15, 1)), sg.InputText()],
                [sg.Text('телефон', size=(15, 1)), sg.InputText()],
                [sg.Text('возраст', size=(15, 1)), sg.InputText()],
                [sg.Submit()]
            ]
            windowEntry = sg.Window('Окно ввода', layout, keep_on_top=True)
            result = ''
            while True:
                eventEntry, valuesEntry = windowEntry.read()
                if eventEntry == 'Submit':
                    if ((str(valuesEntry[6]) != '')&(str(valuesEntry[5]) != '')&(str(valuesEntry[4]) != '')&(str(valuesEntry[3]) != '')&(str(valuesEntry[2]) != '')&(str(valuesEntry[1]) != '')&(str(valuesEntry[0]) != '')):
                        # try:
                        curs.execute("select max(id) from personalinfo;")
                        data = curs.fetchone()
                        string = str(data)
                        sub = string[1:5]
                        id = int(sub) + 1
                        param_list1 = [id, int(valuesEntry[1]),int(valuesEntry[2]),int(valuesEntry[3]),str(valuesEntry[4]),str(valuesEntry[5]),int(valuesEntry[6])]
                        curs.execute("insert into personalinfo values({}, {}, {}, {}, {}, {}, {});".format(id,int(valuesEntry[1]),int(valuesEntry[2]),int(valuesEntry[3]),"'" + str(valuesEntry[4]) + "'", "'" + str(valuesEntry[5]) + "'",int(valuesEntry[6])))
                        curs.execute("insert into patient(name, pi_id)" \
                                     "values( {}, {});".format("'" + str(valuesEntry[0]) + "'", id))

                        connect.commit()
                        break
                    else:
                        sg.popup("Не все поля заполнены!", keep_on_top=True)
                    conn.commit()
                    break

                if eventEntry == sg.WIN_CLOSED:
                    break
            windowEntry.close()
        if event == 'Добавить врача':
            layout = [
                [sg.Text('Пожалуйста, введите необходимые данные.')],
                [sg.Text('name', size=(15, 1)), sg.InputText()],
                [sg.Text('age', size=(15, 1)), sg.InputText()],
                [sg.Text('salary', size=(15, 1)), sg.InputText()],
                [sg.Text('start_work', size=(15, 1)), sg.InputText()],
                [sg.Submit()]
            ]
            windowEntry = sg.Window('Окно ввода', layout, keep_on_top=True)
            result = ''
            while True:
                eventEntry, valuesEntry = windowEntry.read()
                if eventEntry == 'Submit':
                    if ((str(valuesEntry[3]) != '')&(str(valuesEntry[2]) != '')&(str(valuesEntry[1]) != '')&(str(valuesEntry[0]) != '')):
                        # try:
                        age = int(valuesEntry[1])
                        if age > 20:
                            curs.execute("insert into doctor(name, age, salary, startworking)" \
                                           "values( {}, {}, {}, {});".format("'" + str(valuesEntry[0]) + "'",
                                int(valuesEntry[1]), int(valuesEntry[2]),"'" + str(valuesEntry[3]) + "'"))

                            connect.commit()
                        else:
                            sg.popup("Too young!", keep_on_top=True)
                            conn.rollback()
                        break
                    else:
                        sg.popup("Не все поля заполнены!", keep_on_top=True)
                    conn.commit()
                    break

                if eventEntry == sg.WIN_CLOSED:
                    break
            windowEntry.close()
        if event == 'Показать список\nпациентов':
            query = "select name from Patient order by name"
            curs.execute(query)
            data = curs.fetchall()
            my_data = []
            for i in data:
                my_data.append(list(i))
            print(my_data)
            headings = ['name']

            layout = [[sg.Table(values=my_data, headings=headings, max_col_width=35,
                                auto_size_columns=True,
                                display_row_numbers=True,
                                justification='right',
                                num_rows=20,
                                alternating_row_color='lightblue',
                                key='-TABLE-',
                                row_height=35)]]

            windowView = sg.Window('The Table Element', layout)

            while True:
                eventView, valuesView = windowView.read()
                print(eventView, valuesView)
                if eventView == sg.WIN_CLOSED:
                    break
            windowView.close()
        if event == 'Показать список врачей':
            query = "select name, age, salary, startworking from doctor order by name"
            curs.execute(query)
            data = curs.fetchall()
            my_data = []
            for i in data:
                my_data.append(list(i))
            print(my_data)
            headings = ['name', 'age', 'salary', 'start working at']

            layout = [[sg.Table(values=my_data, headings=headings, max_col_width=35,
                                auto_size_columns=True,
                                display_row_numbers=True,
                                justification='right',
                                num_rows=20,
                                alternating_row_color='lightblue',
                                key='-TABLE-',
                                row_height=35)]]

            windowView = sg.Window('The Table Element', layout)

            while True:
                eventView, valuesView = windowView.read()
                print(eventView, valuesView)
                if eventView == sg.WIN_CLOSED:
                    break
            windowView.close()
        eventEntry, valuesEntry = window.Read()
        if event == 'Поиск':
           # windowEntry = sg.Window('Окно ввода', layout, keep_on_top=True)
            result = ''
            while True:
                #eventEntry, valuesEntry = window.Read()
                if eventEntry == 'Поиск':
                    #windowEntry.close()
                    if str(valuesEntry[0]) != '':
                        try:
                            param_list = [str(valuesEntry[0])]
                            curs.execute('CALL form(%s);', param_list)
                            data = curs.fetchall()
                            my_data = []
                            for i in data:
                                my_data.append(list(i))
                            print(my_data)
                            if(my_data == []):
                                sg.popup("Нет такого пациента!")
                            headings = ['name', 'passport serie', 'passport number', 'polis', 'addres', 'phone', 'age']

                            layout = [[sg.Table(values=my_data, headings=headings, max_col_width=35,
                                                auto_size_columns=True,
                                                justification='right',
                                                num_rows=20,
                                                alternating_row_color='lightblue',
                                                key='-TABLE-',
                                                row_height=35)]]

                            windowView = sg.Window('The Table Element', layout, size=(1000, 100))

                            while True:
                                eventView, valuesView = windowView.read()
                                print(eventView, valuesView)
                                if eventView == sg.WIN_CLOSED:
                                    break
                            windowView.close()
                        except (conn.Error) as error:
                            print()
                            sg.popup("Wrong!", keep_on_top=True)
                        break
            #curs.close()
        if event == 'Показать список\nассистентов':
            query = "select name, age, salary from assistent order by name"
            curs.execute(query)
            data = curs.fetchall()
            my_data = []
            for i in data:
                my_data.append(list(i))
            print(my_data)
            headings = ['name', 'age', 'salary']

            layout = [[sg.Table(values=my_data, headings=headings, max_col_width=35,
                                auto_size_columns=True,
                                display_row_numbers=True,
                                justification='right',
                                num_rows=20,
                                alternating_row_color='lightblue',
                                key='-TABLE-',
                                row_height=35)]]

            windowView = sg.Window('The Table Element', layout)

            while True:
                eventView, valuesView = windowView.read()
                print(eventView, valuesView)
                if eventView == sg.WIN_CLOSED:
                    break
            windowView.close()
        eventEntry, valuesEntry = window.Read()
        if event == 'Добавить ассистента':
            layout = [
                [sg.Text('Пожалуйста, введите необходимые данные.')],
                [sg.Text('name', size=(15, 1)), sg.InputText()],
                [sg.Text('age', size=(15, 1)), sg.InputText()],
                [sg.Text('salary', size=(15, 1)), sg.InputText()],
                [sg.Submit()]
            ]
            windowEntry = sg.Window('Окно ввода', layout, keep_on_top=True)
            result = ''
            while True:
                eventEntry, valuesEntry = windowEntry.read()
                if eventEntry == 'Submit':
                    if ((str(valuesEntry[2]) != '')&(str(valuesEntry[1]) != '')&(str(valuesEntry[0]) != '')):
                        # try:
                        age = int(valuesEntry[1])
                        if age > 17:
                            curs.execute("insert into assistent(name, age, salary)" \
                                           "values( {}, {}, {});".format("'" + str(valuesEntry[0]) + "'",
                                int(valuesEntry[1]), int(valuesEntry[2])))
                            sg.popup("Добавлен!")

                            connect.commit()
                        else:
                            sg.popup("Too young!", keep_on_top=True)
                            conn.rollback()
                        break
                    else:
                        sg.popup("Не все поля заполнены!", keep_on_top=True)
                    conn.commit()
                    break

                if eventEntry == sg.WIN_CLOSED:
                    break
            windowEntry.close()
        if event == 'Добавить прием':
            layout = [
                [sg.Text('Пожалуйста, введите необходимые данные.')],
                [sg.Text('Дата', size=(15, 1)), sg.InputText()],
                [sg.Text('Время', size=(15, 1)), sg.InputText()],
                [sg.Text('Тип приема', size=(15, 1)), sg.Combo(comlist_type, size=(15, 1))],
                [sg.Text('Врач', size=(15, 1)), sg.Combo(comlist_doctor, size=(15, 1))],
                [sg.Text('Пациент', size=(15, 1)), sg.InputText()],
                [sg.Text('Диагноз', size=(15, 1)), sg.Combo(comlist_diagnosis, size=(15, 1))],
                [sg.Text('Лечение', size=(15, 1)), sg.InputText()],
                [sg.Submit()]
            ]
            windowEntry = sg.Window('Окно ввода', layout, keep_on_top=True)
            result = ''
            while True:
                eventEntry, valuesEntry = windowEntry.read()
                if eventEntry == 'Submit':
                    if ((str(valuesEntry[6]) != '') &(str(valuesEntry[5]) != '') &(str(valuesEntry[4]) != '') &(str(valuesEntry[3]) != '') & (str(valuesEntry[2]) != '') & (str(valuesEntry[1]) != '') & (
                            str(valuesEntry[0]) != '')):
                        # try:
                        s = str(valuesEntry[6])
                        treat = s[:-1].replace(',', '').split()
                        check_p = 0
                        name = str(valuesEntry[4])
                        print(name)
                        for i in range(0, len(comlist_patient) - 1):
                            print(comlist_patient[i])
                            if (name == comlist_patient[i]):
                                check_p = 1
                        check_t = 0
                        print(treat)
                        for i in range(0, len(treat)):
                            check_t = 0
                            print(treat[i])
                            for j in range(0, len(comlist_treat)):
                                if (treat[i] == comlist_treat[j]):
                                    check_t = 1
                            if check_t == 0:
                                break
                        if (not check_t) :
                            sg.popup("Нет такой услуги!", keep_on_top=True)
                        if (not check_p) :
                            sg.popup("Нет такого пациента!", keep_on_top=True)
                        age = 12
                        if check_t & check_p:
                            treat_l = []
                            for i in range(len(treat)):
                                curs.execute("select idtreatment from treatment where treatment = {};".format("'" + treat[i] + "'"))
                                data = curs.fetchone()
                                s1 = re.sub("[(|'|,|)]", "", str(data))
                                treat_l.append(s1)

                            curs.execute("select max(appointmentid) from appointment;")
                            data = curs.fetchone()
                            sub = re.sub("[(|'|,|)]", "", str(data))
                            id = int(sub) + 1

                            curs.execute("select iddoctor from doctor where name ={};".format("'"+valuesEntry[3]+"'"))
                            data = curs.fetchone()
                            sub = re.sub("[(|'|,|)]", "", str(data))
                            doc = int(sub)

                            curs.execute("select idpatient from patient where name ={};".format("'" + valuesEntry[4] + "'"))
                            data = curs.fetchone()
                            sub = re.sub("[(|'|,|)]", "", str(data))
                            pat = int(sub)

                            curs.execute(
                                "select iddiagnosis from diagnosis where diagnosis ={};".format("'" + valuesEntry[5] + "'"))
                            data = curs.fetchone()
                            sub = re.sub("[(|'|,|)]", "", str(data))
                            diag = int(sub)

                            curs.execute(
                                "select code from typeappointment where type ={};".format("'" + valuesEntry[2] + "'"))
                            data = curs.fetchone()
                            sub = re.sub("[(|'|,|)]", "", str(data))
                            type = int(sub)
                            curs.execute("insert into Appointment(AppointmentID, Date, Time, idDoctor,idPatient, idDiagnosis, typeappointment_code)" \
                                         "values( {}, {}, {}, {}, {}, {}, {});".format(id, "'" + str(valuesEntry[0]) + "'", "'" + str(valuesEntry[1]) + "'",
                                                                           doc, pat, diag,type))
                            for i in range(len(treat_l)):
                                curs.execute("insert into appointmenttreatment values({},{});".format(id, int(treat_l[i])))

                            connect.commit()
                            sg.popup("Прием добавлен!", keep_on_top=True)
                            windowEntry.close()
                    else:
                        sg.popup("Не все поля заполнены!", keep_on_top=True)
                if eventEntry == sg.WIN_CLOSED:
                    break
            windowEntry.close()

    window.close()


