import { remote } from 'webdriverio';

const options = {
    hostname: '127.0.0.1',
    port: 4723,
    path: '/',

    capabilities: {
        platformName: 'Android',
        'appium:automationName': 'UiAutomator2',
        'appium:deviceName': 'emulator-5554',
        'appium:appPackage': 'com.example.student_task_planner',
        'appium:appActivity': '.MainActivity',
        'appium:noReset': true,
    },
};

const driver = await remote(options);


// Tao title rieng cho moi lan test.
// Tranh truong hop tim nham task cu.
const taskTitle = `Appium Task ${Date.now()}`;


/*
 * Dua app ve man Login.
 * Neu dang o man con thi Back.
 * Neu dang o Home thi Logout.
 */
async function goToLogin() {

    console.log('STEP 1: Dua app ve man Login');

    for (let i = 0; i < 6; i++) {

        const loginButton = await driver.$('~LOGIN');

        if (await loginButton.isExisting()) {
            console.log('Da o man Login');
            return;
        }

        const logoutButton = await driver.$('~LOGOUT');

        if (await logoutButton.isExisting()) {

            console.log('Dang o Home -> Logout');

            await logoutButton.click();

            await driver.pause(1000);

            return;
        }

        console.log('Dang o man con -> Back');

        await driver.back();

        await driver.pause(800);
    }

    throw new Error('Khong the dua app ve man Login');
}


/*
 * Login bang tai khoan test.
 */
async function login() {

    console.log('STEP 2: Login');

    const usernameField = await driver.$(
        'android=new UiSelector()' +
        '.className("android.widget.EditText")' +
        '.instance(0)'
    );

    const passwordField = await driver.$(
        'android=new UiSelector()' +
        '.className("android.widget.EditText")' +
        '.instance(1)'
    );

    await usernameField.waitForDisplayed({
        timeout: 10000
    });

    await passwordField.waitForDisplayed({
        timeout: 10000
    });


    // Username
    await usernameField.click();

    await usernameField.clearValue();

    await usernameField.setValue('student');


    // Password
    await passwordField.click();

    await passwordField.clearValue();

    await passwordField.setValue('123456');

    await driver.pause(500);


    // Dong keyboard neu dang mo.
    try {
        await driver.back();
        await driver.pause(500);
    } catch (error) {
        // Khong can xu ly.
    }


    const loginButton = await driver.$('~LOGIN');

    await loginButton.waitForDisplayed({
        timeout: 10000
    });

    await loginButton.click();


    const logoutButton = await driver.$('~LOGOUT');

    await logoutButton.waitForDisplayed({
        timeout: 10000
    });

    console.log('PASS: LOGIN THANH CONG');
}


try {

    console.log('');
    console.log('====================================');
    console.log('START TASK FLOW APPIUM TEST');
    console.log('====================================');
    console.log('Task title: ' + taskTitle);
    console.log('');


    // ============================
    // LOGIN
    // ============================

    await goToLogin();

    await login();


    // ============================
    // MEMBER 2 - MY TASKS
    // ============================

    console.log('STEP 3: Mo My Tasks');

    const myTasksButton = await driver.$(
        'android=new UiSelector().descriptionContains("My Tasks")'
    );

    await myTasksButton.waitForDisplayed({
        timeout: 10000
    });

    await myTasksButton.click();

    await driver.pause(1000);


    const addTaskButton = await driver.$('~Add Task');

    await addTaskButton.waitForDisplayed({
        timeout: 10000
    });

    console.log('PASS: TASK LIST MO THANH CONG');


    // ============================
    // MEMBER 3 - OPEN ADD TASK
    // ============================

    console.log('STEP 4: Mo Add Task');

    await addTaskButton.click();

    await driver.pause(800);


    // ============================
    // TITLE
    // ============================

    console.log('STEP 5: Nhap Title');

    const titleField = await driver.$(
        'android=new UiSelector()' +
        '.className("android.widget.EditText")' +
        '.instance(0)'
    );

    await titleField.waitForDisplayed({
        timeout: 10000
    });

    await titleField.click();

    await titleField.clearValue();

    await titleField.setValue(taskTitle);

    await driver.pause(500);


    // Dong keyboard de tranh che Deadline.
    try {
        await driver.back();
        await driver.pause(500);
    } catch (error) {
        // Khong can xu ly.
    }


    // ============================
    // DEADLINE
    // ============================

    console.log('STEP 6: Chon Deadline');

    const deadlineButton = await driver.$(
        '~Select deadline'
    );

    await deadlineButton.waitForDisplayed({
        timeout: 10000
    });

    await deadlineButton.click();

    await driver.pause(800);


    // Date Picker dang mac dinh chon ngay hom nay.
    // Chi can bam OK.
    const okButton = await driver.$(
        'android=new UiSelector().text("OK")'
    );

    await okButton.waitForDisplayed({
        timeout: 10000
    });

    await okButton.click();

    await driver.pause(800);

    console.log('PASS: DEADLINE DA DUOC CHON');


    // ============================
    // PRIORITY
    // ============================

    // Priority mac dinh = Medium.
    // Khong can thay doi trong flow co ban.

    console.log('STEP 7: Priority mac dinh = Medium');


    // ============================
    // SAVE TASK
    // ============================

    console.log('STEP 8: Save Task');

    const saveTaskButton = await driver.$(
        '~Save Task'
    );

    await saveTaskButton.waitForDisplayed({
        timeout: 10000
    });

    await saveTaskButton.click();

    await driver.pause(1200);


    // ============================
    // VERIFY TASK
    // ============================

    console.log('STEP 9: Kiem tra task vua tao');

    const createdTask = await driver.$(
        `android=new UiSelector().descriptionContains("${taskTitle}")`
    );

    await createdTask.waitForDisplayed({
        timeout: 10000
    });

    console.log('PASS: ADD TASK THANH CONG');

    console.log(
        'PASS: TASK XUAT HIEN TRONG DANH SACH'
    );


    // ============================
    // BACK TO HOME
    // ============================

    console.log('STEP 10: Quay ve Home');

    await driver.back();

    await driver.pause(1000);


    const logoutButton = await driver.$(
        '~LOGOUT'
    );

    await logoutButton.waitForDisplayed({
        timeout: 10000
    });

    console.log('PASS: DA QUAY VE HOME');


    // ============================
    // REOPEN MY TASKS
    // ============================

    console.log(
        'STEP 11: Mo lai My Tasks de kiem tra task con ton tai'
    );

    const myTasksAgain = await driver.$(
        'android=new UiSelector().descriptionContains("My Tasks")'
    );

    await myTasksAgain.waitForDisplayed({
        timeout: 10000
    });

    await myTasksAgain.click();

    await driver.pause(800);


    const savedTaskAgain = await driver.$(
        `android=new UiSelector().descriptionContains("${taskTitle}")`
    );

    await savedTaskAgain.waitForDisplayed({
        timeout: 10000
    });

    console.log(
        'PASS: TASK VAN CON SAU KHI MO LAI MY TASKS'
    );


    // Quay lai Home.
    await driver.back();

    await driver.pause(800);


    // ============================
    // LOGOUT
    // ============================

    console.log('STEP 12: Logout');

    const logoutFinal = await driver.$(
        '~LOGOUT'
    );

    await logoutFinal.waitForDisplayed({
        timeout: 10000
    });

    await logoutFinal.click();

    await driver.pause(1000);


    const loginAfterLogout = await driver.$(
        '~LOGIN'
    );

    await loginAfterLogout.waitForDisplayed({
        timeout: 10000
    });

    console.log('PASS: LOGOUT THANH CONG');


    // ============================
    // COMPLETE
    // ============================

    console.log('');
    console.log('====================================');
    console.log('TEST COMPLETED SUCCESSFULLY');
    console.log('====================================');


} catch (error) {

    console.log('');
    console.log('====================================');
    console.log('FAIL: TASK FLOW TEST BI LOI');
    console.log('====================================');

    console.error(error.message);


} finally {

    try {

        await driver.deleteSession();

    } catch (error) {

        console.log('Session da ket thuc');

    }
}