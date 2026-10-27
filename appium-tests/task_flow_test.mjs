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

const taskTitle = `Appium Task ${Date.now()}`;


// ============================================================
// HELPER: Dua app ve Login
// ============================================================

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

            const loginAfterLogout = await driver.$('~LOGIN');

            await loginAfterLogout.waitForDisplayed({
                timeout: 10000,
            });

            return;
        }

        console.log('Dang o man con -> Back');

        await driver.back();
        await driver.pause(800);
    }

    throw new Error('Khong the dua app ve man Login');
}


// ============================================================
// HELPER: Login
// ============================================================

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
        timeout: 10000,
    });

    await passwordField.waitForDisplayed({
        timeout: 10000,
    });

    await usernameField.click();
    await usernameField.clearValue();
    await usernameField.setValue('student');

    await passwordField.click();
    await passwordField.clearValue();
    await passwordField.setValue('123456');

    await driver.pause(500);


    /*
     * KHONG Back ngay lap tuc.
     * Chi Back neu nut LOGIN thuc su chua hien thi.
     */
    let loginButton = await driver.$('~LOGIN');

    let loginVisible = false;

    try {
        loginVisible = await loginButton.isDisplayed();
    } catch (error) {
        loginVisible = false;
    }

    if (!loginVisible) {
        console.log('LOGIN bi keyboard che -> dong keyboard 1 lan');

        await driver.back();
        await driver.pause(700);

        loginButton = await driver.$('~LOGIN');
    }

    await loginButton.waitForDisplayed({
        timeout: 10000,
    });

    await loginButton.click();

    const logoutButton = await driver.$('~LOGOUT');

    await logoutButton.waitForDisplayed({
        timeout: 10000,
    });

    console.log('PASS: LOGIN THANH CONG');
}


// ============================================================
// HELPER: Tim Deadline
// ============================================================

async function findDeadlineButton() {
    let deadlineButton = await driver.$(
        '~Select deadline'
    );

    if (await deadlineButton.isExisting()) {
        return deadlineButton;
    }

    deadlineButton = await driver.$(
        'android=new UiSelector()' +
        '.description("Select deadline")'
    );

    if (await deadlineButton.isExisting()) {
        return deadlineButton;
    }

    deadlineButton = await driver.$(
        'android=new UiSelector()' +
        '.descriptionContains("deadline")'
    );

    if (await deadlineButton.isExisting()) {
        return deadlineButton;
    }

    throw new Error(
        'Khong tim thay nut Select deadline'
    );
}


// ============================================================
// HELPER: Tim nut OK Date Picker
// ============================================================

async function findDatePickerOkButton() {
    console.log('Dang tim nut OK cua Date Picker');

    const selectors = [
        {
            name: 'resourceId',
            value:
                'android=new UiSelector()' +
                '.resourceId("android:id/button1")',
        },

        {
            name: 'text OK',
            value:
                'android=new UiSelector().text("OK")',
        },

        {
            name: 'description OK',
            value:
                'android=new UiSelector().description("OK")',
        },

        {
            name: 'accessibility id',
            value: '~OK',
        },

        {
            name: 'XPath text',
            value: '//*[@text="OK"]',
        },

        {
            name: 'XPath content-desc',
            value: '//*[@content-desc="OK"]',
        },
    ];

    for (const selector of selectors) {
        const element = await driver.$(
            selector.value
        );

        if (await element.isExisting()) {
            console.log(
                `Tim thay OK bang ${selector.name}`
            );

            return element;
        }
    }

    throw new Error(
        'Khong tim thay nut OK trong Date Picker'
    );
}


// ============================================================
// HELPER: Tim task theo title
// ============================================================

async function findTaskByTitle(title) {
    const selectors = [
        `android=new UiSelector().text("${title}")`,

        `android=new UiSelector().textContains("${title}")`,

        `android=new UiSelector().descriptionContains("${title}")`,
    ];

    for (const selector of selectors) {
        const task = await driver.$(selector);

        if (await task.isExisting()) {
            return task;
        }
    }

    throw new Error(
        `Khong tim thay task: ${title}`
    );
}


// ============================================================
// MAIN TEST
// ============================================================

try {
    console.log('');
    console.log('====================================');
    console.log('START TASK FLOW APPIUM TEST');
    console.log('====================================');
    console.log('Task title: ' + taskTitle);
    console.log('');


    // ========================================================
    // MEMBER 1 - LOGIN
    // ========================================================

    await goToLogin();

    await login();


    // ========================================================
    // MEMBER 2 - MY TASKS
    // ========================================================

    console.log('STEP 3: Mo My Tasks');

    const myTasksButton = await driver.$(
        'android=new UiSelector()' +
        '.descriptionContains("My Tasks")'
    );

    await myTasksButton.waitForDisplayed({
        timeout: 10000,
    });

    await myTasksButton.click();

    await driver.pause(1000);


    const addTaskButton = await driver.$(
        '~Add Task'
    );

    await addTaskButton.waitForDisplayed({
        timeout: 10000,
    });

    console.log(
        'PASS: TASK LIST MO THANH CONG'
    );


    // ========================================================
    // MEMBER 3 - OPEN ADD TASK
    // ========================================================

    console.log('STEP 4: Mo Add Task');

    await addTaskButton.click();

    await driver.pause(1000);


    // ========================================================
    // TITLE
    // ========================================================

    console.log('STEP 5: Nhap Title');

    const titleField = await driver.$(
        'android=new UiSelector()' +
        '.className("android.widget.EditText")' +
        '.instance(0)'
    );

    await titleField.waitForDisplayed({
        timeout: 10000,
    });

    await titleField.click();

    await titleField.clearValue();

    await titleField.setValue(taskTitle);

    await driver.pause(500);

    console.log('PASS: DA NHAP TITLE');


    /*
     * QUAN TRONG:
     *
     * KHONG driver.back()
     * KHONG hideKeyboard()
     *
     * Di thang toi Deadline.
     */


    // ========================================================
    // DEADLINE
    // ========================================================

    console.log('STEP 6: Chon Deadline');

    const deadlineButton =
        await findDeadlineButton();

    await deadlineButton.waitForExist({
        timeout: 10000,
    });

    console.log('Da tim thay Deadline');


    /*
     * Thu click truc tiep.
     * Khong dong keyboard.
     */
    await deadlineButton.click();

    await driver.pause(1200);


    /*
     * Kiem tra Date Picker da mo bang nut OK.
     */
    const okButton =
        await findDatePickerOkButton();

    await okButton.waitForDisplayed({
        timeout: 10000,
    });

    console.log('Date Picker da mo');

    await okButton.click();

    await driver.pause(1000);

    console.log(
        'PASS: DEADLINE DA DUOC CHON'
    );


    // ========================================================
    // PRIORITY
    // ========================================================

    console.log(
        'STEP 7: Priority mac dinh = Medium'
    );


    // ========================================================
    // SAVE TASK
    // ========================================================

    console.log('STEP 8: Save Task');

    const saveTaskButton =
        await driver.$(
            '~Save Task'
        );

    await saveTaskButton.waitForDisplayed({
        timeout: 10000,
    });

    await saveTaskButton.click();

    await driver.pause(1500);


    // ========================================================
    // VERIFY TASK
    // ========================================================

    console.log(
        'STEP 9: Kiem tra task vua tao'
    );

    const createdTask =
        await findTaskByTitle(
            taskTitle
        );

    await createdTask.waitForDisplayed({
        timeout: 10000,
    });

    console.log(
        'PASS: ADD TASK THANH CONG'
    );

    console.log(
        'PASS: TASK XUAT HIEN TRONG DANH SACH'
    );


    // ========================================================
    // BACK HOME
    // ========================================================

    console.log(
        'STEP 10: Quay ve Home'
    );

    await driver.back();

    await driver.pause(1000);


    const logoutButton =
        await driver.$(
            '~LOGOUT'
        );

    await logoutButton.waitForDisplayed({
        timeout: 10000,
    });

    console.log(
        'PASS: DA QUAY VE HOME'
    );


    // ========================================================
    // REOPEN MY TASKS
    // ========================================================

    console.log(
        'STEP 11: Mo lai My Tasks'
    );

    const myTasksAgain =
        await driver.$(
            'android=new UiSelector()' +
            '.descriptionContains("My Tasks")'
        );

    await myTasksAgain.waitForDisplayed({
        timeout: 10000,
    });

    await myTasksAgain.click();

    await driver.pause(1000);


    const savedTaskAgain =
        await findTaskByTitle(
            taskTitle
        );

    await savedTaskAgain.waitForDisplayed({
        timeout: 10000,
    });

    console.log(
        'PASS: TASK VAN CON SAU KHI MO LAI MY TASKS'
    );


    // ========================================================
    // BACK HOME
    // ========================================================

    console.log(
        'STEP 12: Quay lai Home'
    );

    await driver.back();

    await driver.pause(800);


    // ========================================================
    // LOGOUT
    // ========================================================

    console.log(
        'STEP 13: Logout'
    );

    const logoutFinal =
        await driver.$(
            '~LOGOUT'
        );

    await logoutFinal.waitForDisplayed({
        timeout: 10000,
    });

    await logoutFinal.click();

    await driver.pause(1000);


    const loginAfterLogout =
        await driver.$(
            '~LOGIN'
        );

    await loginAfterLogout.waitForDisplayed({
        timeout: 10000,
    });

    console.log(
        'PASS: LOGOUT THANH CONG'
    );


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
        console.log(
            'Session da ket thuc'
        );
    }
}