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

/**
 * Tìm nút LOGIN.
 * Nếu chưa thấy, có thể bàn phím đang che/hierarchy chưa cập nhật,
 * lúc đó thử Back một lần để đóng keyboard rồi tìm lại.
 */
async function findLoginButton() {

    // Cách 1: accessibility id
    let loginButton = await driver.$('~LOGIN');

    if (await loginButton.isExisting()) {
        return loginButton;
    }

    console.log('Chưa thấy LOGIN -> thử đóng bàn phím');

    try {
        await driver.back();
        await driver.pause(1200);
    } catch (error) {
        console.log('Không cần đóng bàn phím hoặc Back không thực hiện được');
    }

    // Thử lại accessibility id
    loginButton = await driver.$('~LOGIN');

    if (await loginButton.isExisting()) {
        return loginButton;
    }

    // Cách 2: Android UiAutomator
    loginButton = await driver.$(
        'android=new UiSelector().description("LOGIN")'
    );

    if (await loginButton.isExisting()) {
        return loginButton;
    }

    // Cách 3: XPath dự phòng
    loginButton = await driver.$(
        '//android.widget.Button[@content-desc="LOGIN"]'
    );

    if (await loginButton.isExisting()) {
        return loginButton;
    }

    throw new Error('Không tìm thấy nút LOGIN');
}


try {

    console.log('');
    console.log('============================');
    console.log('START LOGIN TEST');
    console.log('============================');

    /*
     * STEP 1
     * Nếu app hiện đang ở Home,
     * logout để đưa app về trạng thái Login ban đầu.
     */
    console.log('STEP 1: Kiểm tra trạng thái app');

    const logoutButton = await driver.$('~LOGOUT');

    if (await logoutButton.isExisting()) {

        console.log('App đang ở Home -> Logout');

        await logoutButton.click();
        await driver.pause(1200);

    } else {

        console.log('App đang ở màn Login');

    }


    /*
     * STEP 2
     * Tìm Username và Password.
     */
    console.log('STEP 2: Tìm Username và Password');

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

    console.log('Đã tìm thấy 2 ô input');


    /*
     * STEP 3
     * Xóa dữ liệu cũ rồi nhập Username.
     */
    console.log('STEP 3: Nhập Username');

    await usernameField.click();

    await usernameField.clearValue();

    await driver.pause(300);

    await driver.keys('student');

    await driver.pause(500);

    console.log('Username = student');


    /*
     * STEP 4
     * Xóa dữ liệu cũ rồi nhập Password.
     */
    console.log('STEP 4: Nhập Password');

    await passwordField.click();

    await passwordField.clearValue();

    await driver.pause(300);

    await driver.keys('123456');

    await driver.pause(700);

    console.log('Password đã nhập');


    /*
     * STEP 5
     * Tìm nút LOGIN.
     */
    console.log('STEP 5: Tìm nút LOGIN');

    const loginButton = await findLoginButton();

    await loginButton.waitForDisplayed({
        timeout: 10000
    });

    console.log('Đã tìm thấy nút LOGIN');


    /*
     * STEP 6
     * Click LOGIN.
     */
    console.log('STEP 6: Bấm LOGIN');

    await loginButton.click();

    console.log('Đã bấm LOGIN');

    await driver.pause(1500);


    /*
     * STEP 7
     * Kiểm tra Home Dashboard.
     * Nếu LOGOUT xuất hiện tức là Login thành công.
     */
    console.log('STEP 7: Kiểm tra Home Dashboard');

    const logoutAfterLogin = await driver.$('~LOGOUT');

    await logoutAfterLogin.waitForDisplayed({
        timeout: 10000
    });

    console.log('');
    console.log('PASS: LOGIN THÀNH CÔNG');
    console.log('PASS: ĐÃ VÀO HOME DASHBOARD');


    /*
     * STEP 8
     * Logout để đưa app về trạng thái ban đầu.
     */
    console.log('STEP 8: Logout');

    await logoutAfterLogin.click();

    await driver.pause(1000);


    /*
     * Kiểm tra đã quay lại Login.
     */
    const loginAfterLogout = await driver.$('~LOGIN');

    await loginAfterLogout.waitForDisplayed({
        timeout: 10000
    });

    console.log('PASS: LOGOUT THÀNH CÔNG');

    console.log('');
    console.log('============================');
    console.log('TEST COMPLETED SUCCESSFULLY');
    console.log('============================');


} catch (error) {

    console.log('');
    console.log('============================');
    console.log('FAIL: TEST BỊ LỖI');
    console.log('============================');

    console.error(error.message);

} finally {

    try {
        await driver.deleteSession();
    } catch (error) {
        console.log('Session đã kết thúc');
    }

}