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

const pendingTitle =
    `M4 Pending ${Date.now()}`;

const completedTitle =
    `M4 Completed ${Date.now()}`;

const TIMEOUT = 10000;


// ============================================================
// STEP 1 - DUA APP VE LOGIN
// PHAN NAY GIU THEO FLOW DA TUNG PASS
// ============================================================

async function goToLogin() {

    console.log(
        'STEP 1: Dua app ve man Login'
    );

    for (let i = 0; i < 6; i++) {

        const loginButton =
            await driver.$('~LOGIN');

        if (await loginButton.isExisting()) {

            console.log(
                'Da o man Login'
            );

            return;
        }


        const logoutButton =
            await driver.$('~LOGOUT');

        if (await logoutButton.isExisting()) {

            console.log(
                'Dang o Home -> Logout'
            );

            await logoutButton.click();

            await driver.pause(1000);


            const loginAfterLogout =
                await driver.$('~LOGIN');


            await loginAfterLogout
                .waitForDisplayed({
                    timeout: TIMEOUT,
                });


            console.log(
                'Da dua app ve Login'
            );

            return;
        }


        console.log(
            'Dang o man con -> Back'
        );

        await driver.back();

        await driver.pause(800);
    }


    throw new Error(
        'Khong the dua app ve Login'
    );
}


// ============================================================
// STEP 2 - LOGIN
// GIU DUNG FLOW DA TUNG PASS
// ============================================================

async function login() {

    console.log(
        'STEP 2: Login'
    );


    const usernameField =
        await driver.$(

            'android=new UiSelector()' +
            '.className("android.widget.EditText")' +
            '.instance(0)'
        );


    const passwordField =
        await driver.$(

            'android=new UiSelector()' +
            '.className("android.widget.EditText")' +
            '.instance(1)'
        );


    await usernameField
        .waitForDisplayed({
            timeout: TIMEOUT,
        });


    await passwordField
        .waitForDisplayed({
            timeout: TIMEOUT,
        });


    await usernameField.click();

    await usernameField.clearValue();

    await usernameField.setValue(
        'student'
    );


    await passwordField.click();

    await passwordField.clearValue();

    await passwordField.setValue(
        '123456'
    );


    await driver.pause(500);


    // LOGIN thuong bi keyboard che.
    // Chi Back khi LOGIN chua hien.
    let loginButton =
        await driver.$('~LOGIN');


    let loginVisible = false;


    try {

        loginVisible =
            await loginButton.isDisplayed();

    } catch (error) {

        loginVisible = false;
    }


    if (!loginVisible) {

        console.log(
            'Keyboard dang che LOGIN -> dong keyboard'
        );

        await driver.back();

        await driver.pause(600);


        loginButton =
            await driver.$('~LOGIN');
    }


    await loginButton
        .waitForDisplayed({
            timeout: TIMEOUT,
        });


    await loginButton.click();


    const logoutButton =
        await driver.$('~LOGOUT');


    await logoutButton
        .waitForDisplayed({
            timeout: TIMEOUT,
        });


    console.log(
        'PASS: LOGIN'
    );
}


// ============================================================
// DATE PICKER
// ============================================================

async function findOkButton() {

    const selectors = [

        'android=new UiSelector()' +
        '.resourceId("android:id/button1")',

        'android=new UiSelector()' +
        '.text("OK")',

        'android=new UiSelector()' +
        '.description("OK")',

        '~OK',

        '//*[@text="OK"]',

        '//*[@content-desc="OK"]',
    ];


    for (const selector of selectors) {

        const element =
            await driver.$(selector);


        if (await element.isExisting()) {

            return element;
        }
    }


    throw new Error(
        'Khong tim thay nut OK cua Date Picker'
    );
}


// ============================================================
// TASK FIND
// ============================================================

async function taskExists(title) {

    const selectors = [

        `android=new UiSelector()` +
        `.descriptionContains("${title}")`,

        `android=new UiSelector()` +
        `.text("${title}")`,

        `android=new UiSelector()` +
        `.textContains("${title}")`,
    ];


    for (const selector of selectors) {

        const task =
            await driver.$(selector);


        if (await task.isExisting()) {

            return true;
        }
    }


    return false;
}


// ============================================================
// SCROLL TIM ELEMENT
// CHI DUNG TRONG TASK LIST
// KHONG DUNG CHO LOGIN
// ============================================================

async function scrollToDescription(
    description
) {

    const selector =

        'android=new UiScrollable(' +
        'new UiSelector().scrollable(true)' +
        ')' +

        '.setMaxSearchSwipes(10)' +

        '.scrollIntoView(' +
        'new UiSelector()' +
        `.description("${description}")` +
        ')';


    try {

        const element =
            await driver.$(selector);


        if (await element.isExisting()) {

            return element;
        }

    } catch (error) {

        // Neu list khong can scroll thi bo qua.
    }


    return null;
}


// ============================================================
// FIND TASK CO SCROLL
// ============================================================

async function findTaskWithScroll(title) {

    // Thu tim truc tiep truoc.
    const direct =
        await driver.$(

            `android=new UiSelector()` +
            `.descriptionContains("${title}")`
        );


    if (await direct.isExisting()) {

        return direct;
    }


    // Neu khong thay thi scroll.
    const selector =

        'android=new UiScrollable(' +
        'new UiSelector().scrollable(true)' +
        ')' +

        '.setMaxSearchSwipes(10)' +

        '.scrollIntoView(' +
        'new UiSelector()' +
        `.descriptionContains("${title}")` +
        ')';


    const element =
        await driver.$(selector);


    await element.waitForDisplayed({
        timeout: TIMEOUT,
    });


    return element;
}


// ============================================================
// CREATE TASK
// GIU FLOW ADD TASK DA TUNG PASS
// ============================================================

async function createTask(title) {

    console.log(
        `Tao task: ${title}`
    );


    const addTaskButton =
        await driver.$(
            '~Add Task'
        );


    await addTaskButton
        .waitForDisplayed({
            timeout: TIMEOUT,
        });


    await addTaskButton.click();

    await driver.pause(700);


    const titleField =
        await driver.$(

            'android=new UiSelector()' +
            '.className("android.widget.EditText")' +
            '.instance(0)'
        );


    await titleField
        .waitForDisplayed({
            timeout: TIMEOUT,
        });


    await titleField.click();

    await titleField.clearValue();

    await titleField.setValue(
        title
    );


    await driver.pause(400);


    // QUAN TRONG:
    // Khong driver.back() o day.
    const deadlineButton =
        await driver.$(
            '~Select deadline'
        );


    await deadlineButton
        .waitForExist({
            timeout: TIMEOUT,
        });


    await deadlineButton.click();

    await driver.pause(800);


    const okButton =
        await findOkButton();


    await okButton
        .waitForDisplayed({
            timeout: TIMEOUT,
        });


    await okButton.click();

    await driver.pause(700);


    const saveButton =
        await driver.$(
            '~Save Task'
        );


    await saveButton
        .waitForDisplayed({
            timeout: TIMEOUT,
        });


    await saveButton.click();

    await driver.pause(1000);


    // Neu task bi nam duoi man hinh
    // thi tu scroll toi.
    await findTaskWithScroll(
        title
    );


    console.log(
        `PASS: DA TAO ${title}`
    );
}


// ============================================================
// CHECKBOX
// ============================================================

async function getToggle(title) {

    let toggle =
        await driver.$(
            `~Toggle ${title}`
        );


    if (await toggle.isExisting()) {

        try {

            if (await toggle.isDisplayed()) {

                return toggle;
            }

        } catch (error) {

            // Thu scroll.
        }
    }


    toggle =
        await scrollToDescription(
            `Toggle ${title}`
        );


    if (!toggle) {

        throw new Error(
            `Khong tim thay checkbox: ${title}`
        );
    }


    await toggle.waitForDisplayed({
        timeout: TIMEOUT,
    });


    return toggle;
}


// ============================================================
// DOI STATUS VA KIEM TRA
// ============================================================

async function toggleAndCheck(
    title,
    expected
) {

    let toggle =
        await getToggle(title);


    await toggle.click();

    await driver.pause(700);


    // Flutter rebuild widget sau click,
    // nen lay lai element.
    toggle =
        await getToggle(title);


    const checked =
        String(
            await toggle.getAttribute(
                'checked'
            )
        );


    if (checked !== expected) {

        throw new Error(
            `Checkbox ${title} expected=${expected}, actual=${checked}`
        );
    }
}


// ============================================================
// DELETE BUTTON
// ============================================================

async function getDeleteButton(title) {

    let button =
        await driver.$(
            `~Delete ${title}`
        );


    if (await button.isExisting()) {

        try {

            if (await button.isDisplayed()) {

                return button;
            }

        } catch (error) {

            // Thu scroll.
        }
    }


    button =
        await scrollToDescription(
            `Delete ${title}`
        );


    if (!button) {

        throw new Error(
            `Khong tim thay Delete: ${title}`
        );
    }


    await button.waitForDisplayed({
        timeout: TIMEOUT,
    });


    return button;
}


// ============================================================
// DIALOG BUTTON
// ============================================================

async function findDialogButton(name) {

    const selectors = [

        `~${name}`,

        `android=new UiSelector()` +
        `.text("${name}")`,

        `android=new UiSelector()` +
        `.description("${name}")`,

        `//*[@text="${name}"]`,

        `//*[@content-desc="${name}"]`,
    ];


    for (const selector of selectors) {

        const button =
            await driver.$(selector);


        if (await button.isExisting()) {

            return button;
        }
    }


    throw new Error(
        `Khong tim thay button ${name}`
    );
}


// ============================================================
// MAIN TEST
// ============================================================

try {

    console.log('');

    console.log(
        '===================================='
    );

    console.log(
        'START MEMBER 4 APPIUM TEST'
    );

    console.log(
        '===================================='
    );

    console.log(
        'Pending task: ' + pendingTitle
    );

    console.log(
        'Completed task: ' + completedTitle
    );

    console.log('');


    // ========================================================
    // LOGIN
    // ========================================================

    await goToLogin();

    await login();


    // ========================================================
    // MY TASKS
    // ========================================================

    console.log(
        'STEP 3: Mo My Tasks'
    );


    const myTasksButton =
        await driver.$(

            'android=new UiSelector()' +
            '.descriptionContains("My Tasks")'
        );


    await myTasksButton
        .waitForDisplayed({
            timeout: TIMEOUT,
        });


    await myTasksButton.click();

    await driver.pause(800);


    console.log(
        'PASS: MO MY TASKS'
    );


    // ========================================================
    // CREATE 2 TASK
    // ========================================================

    console.log(
        'STEP 4: Tao 2 task'
    );


    await createTask(
        pendingTitle
    );


    await createTask(
        completedTitle
    );


    // ========================================================
    // PENDING -> COMPLETED
    // ========================================================

    console.log(
        'STEP 5: Pending -> Completed'
    );


    await toggleAndCheck(
        completedTitle,
        'true'
    );


    console.log(
        'PASS: PENDING -> COMPLETED'
    );


    // ========================================================
    // COMPLETED -> PENDING
    // ========================================================

    console.log(
        'STEP 6: Completed -> Pending'
    );


    await toggleAndCheck(
        completedTitle,
        'false'
    );


    console.log(
        'PASS: COMPLETED -> PENDING'
    );


    // ========================================================
    // CHUYEN LAI COMPLETED DE TEST FILTER
    // ========================================================

    await toggleAndCheck(
        completedTitle,
        'true'
    );


    console.log(
        'PASS: CHUAN BI 1 PENDING + 1 COMPLETED'
    );


    // ========================================================
    // HOME
    // ========================================================

    console.log(
        'STEP 7: Quay ve Home'
    );


    await driver.back();

    await driver.pause(800);


    const logoutHome =
        await driver.$(
            '~LOGOUT'
        );


    await logoutHome
        .waitForDisplayed({
            timeout: TIMEOUT,
        });


    console.log(
        'PASS: DA QUAY VE HOME'
    );


    // ========================================================
    // PENDING FILTER
    // ========================================================

    console.log(
        'STEP 8: Pending Filter'
    );


    const pendingCard =
        await driver.$(

            'android=new UiSelector()' +
            '.descriptionContains("Pending")'
        );


    await pendingCard
        .waitForDisplayed({
            timeout: TIMEOUT,
        });


    await pendingCard.click();

    await driver.pause(800);


    if (
        !(await taskExists(
            pendingTitle
        ))
    ) {

        throw new Error(
            'Pending task khong hien trong Pending Filter'
        );
    }


    if (
        await taskExists(
            completedTitle
        )
    ) {

        throw new Error(
            'Completed task lai hien trong Pending Filter'
        );
    }


    console.log(
        'PASS: PENDING FILTER'
    );


    // ========================================================
    // HOME
    // ========================================================

    await driver.back();

    await driver.pause(700);


    // ========================================================
    // COMPLETED FILTER
    // ========================================================

    console.log(
        'STEP 9: Completed Filter'
    );


    const completedCard =
        await driver.$(

            'android=new UiSelector()' +
            '.descriptionContains("Completed")'
        );


    await completedCard
        .waitForDisplayed({
            timeout: TIMEOUT,
        });


    await completedCard.click();

    await driver.pause(800);


    if (
        !(await taskExists(
            completedTitle
        ))
    ) {

        throw new Error(
            'Completed task khong hien trong Completed Filter'
        );
    }


    if (
        await taskExists(
            pendingTitle
        )
    ) {

        throw new Error(
            'Pending task lai hien trong Completed Filter'
        );
    }


    console.log(
        'PASS: COMPLETED FILTER'
    );


    // ========================================================
    // BACK HOME
    // ========================================================

    await driver.back();

    await driver.pause(700);


    // ========================================================
    // MY TASKS AGAIN
    // ========================================================

    console.log(
        'STEP 10: Mo lai My Tasks'
    );


    const myTasksAgain =
        await driver.$(

            'android=new UiSelector()' +
            '.descriptionContains("My Tasks")'
        );


    await myTasksAgain
        .waitForDisplayed({
            timeout: TIMEOUT,
        });


    await myTasksAgain.click();

    await driver.pause(800);


    // ========================================================
    // DELETE CANCEL
    // ========================================================

    console.log(
        'STEP 11: Delete Cancel'
    );


    let deletePending =
        await getDeleteButton(
            pendingTitle
        );


    await deletePending.click();

    await driver.pause(500);


    const cancelButton =
        await findDialogButton(
            'Cancel'
        );


    await cancelButton.click();

    await driver.pause(600);


    if (
        !(await taskExists(
            pendingTitle
        ))
    ) {

        throw new Error(
            'Task bi xoa sau khi bam Cancel'
        );
    }


    console.log(
        'PASS: DELETE CANCEL'
    );


    // ========================================================
    // DELETE CONFIRM
    // ========================================================

    console.log(
        'STEP 12: Delete Confirm'
    );


    // Lay lai button moi.
    deletePending =
        await getDeleteButton(
            pendingTitle
        );


    await deletePending.click();

    await driver.pause(500);


    const deleteConfirm =
        await findDialogButton(
            'Delete'
        );


    await deleteConfirm.click();

    await driver.pause(800);


    if (
        await taskExists(
            pendingTitle
        )
    ) {

        throw new Error(
            'Task van con sau khi Delete'
        );
    }


    console.log(
        'PASS: DELETE CONFIRM'
    );


    // ========================================================
    // BACK HOME
    // ========================================================

    console.log(
        'STEP 13: Quay ve Home'
    );


    await driver.back();

    await driver.pause(800);


    const homeCheck =
        await driver.$(
            '~LOGOUT'
        );


    await homeCheck
        .waitForDisplayed({
            timeout: TIMEOUT,
        });


    console.log(
        'PASS: DA QUAY VE HOME'
    );


    // ========================================================
    // MEMBER 4 COMPLETE
    // KHONG TEST LOGOUT O DAY
    // LOGOUT DA CO MEMBER 1 / TASK FLOW TEST RIENG
    // ========================================================

    console.log('');

    console.log(
        '===================================='
    );

    console.log(
        'MEMBER 4 TEST COMPLETED SUCCESSFULLY'
    );

    console.log(
        '===================================='
    );


} catch (error) {

    console.log('');

    console.log(
        '===================================='
    );

    console.log(
        'FAIL: MEMBER 4 TEST BI LOI'
    );

    console.log(
        '===================================='
    );


    console.error(
        error.message
    );


} finally {

    try {

        await driver.deleteSession();

    } catch (error) {

        console.log(
            'Session da ket thuc'
        );
    }
}