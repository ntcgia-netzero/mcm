import React, { useState } from 'react';
import { View, Text, TextInput, TouchableOpacity, StyleSheet, Alert, ActivityIndicator, ScrollView } from 'react-native';

export default function Login() {
    const [account, setAccount] = useState('');
    const [password, setPassword] = useState('');
    const [accountError, setAccountError] = useState(null);
    const [passwordError, setPasswordError] = useState(null);
    const [loading, setLoading] = useState(false);

    const checkForm = () => {
        if (!account.trim()) {
            setAccountError('帳號不可為空');
            setLoading(false);
            return false;
        }

        if (!password.trim()) {
            setPasswordError('密碼不可為空');
            setLoading(false);
            return false;
        }

        return true;
    };

    const login = () => {
        setLoading(true);
        setAccountError(null);
        setPasswordError(null);

        if (!checkForm()) return;

        // Network call removed. Only show success message.
        setTimeout(() => {
            setLoading(false);
            Alert.alert('Login', 'Login pressed');
        }, 1000);
    };

    return (
        <ScrollView contentContainerStyle={styles.container}>
            <View style={styles.logoContainer}>
                <Text style={styles.logoText}>Micro</Text>
                <Text style={styles.logoText}>Carbon</Text>
                <Text style={styles.logoText}>Management</Text>
            </View>
            <View style={styles.form}>
                <View style={styles.inputGroup}>
                    <Text style={styles.label}>帳號</Text>
                    <TextInput
                        style={styles.input}
                        value={account}
                        onChangeText={setAccount}
                    />
                    {accountError && <Text style={styles.error}>{accountError}</Text>}
                </View>
                <View style={[styles.inputGroup, { marginTop: 20 }]}>
                    <Text style={styles.label}>密碼</Text>
                    <TextInput
                        style={styles.input}
                        value={password}
                        onChangeText={setPassword}
                        secureTextEntry
                    />
                    {passwordError && <Text style={styles.error}>{passwordError}</Text>}
                </View>
                <View style={{ marginTop: 60 }}>
                    <TouchableOpacity style={styles.buttonBlue} onPress={login} disabled={loading}>
                        {loading ? <ActivityIndicator color="#fff" /> : <Text style={styles.buttonText}>登入</Text>}
                    </TouchableOpacity>
                </View>
                <View style={{ marginTop: 20 }}>
                    <TouchableOpacity style={styles.buttonGray} onPress={() => Alert.alert('Register', 'Register pressed')}>
                        <Text style={styles.buttonText}>註冊</Text>
                    </TouchableOpacity>
                </View>
            </View>
        </ScrollView>
    );
}

const styles = StyleSheet.create({
    container: {
        flexGrow: 1,
        backgroundColor: '#fff',
        alignItems: 'center'
    },
    logoContainer: {
        height: 300,
        width: '100%',
        backgroundColor: '#448fda',
        justifyContent: 'space-between',
        alignItems: 'flex-start',
        paddingVertical: 50,
        paddingHorizontal: 25
    },
    logoText: {
        color: '#fff',
        fontSize: 45,
        fontWeight: '900'
    },
    form: {
        width: '100%',
        paddingHorizontal: 40,
        alignItems: 'center'
    },
    inputGroup: {
        alignSelf: 'stretch'
    },
    label: {
        fontSize: 15,
        fontWeight: '600'
    },
    input: {
        height: 40,
        backgroundColor: '#efefef',
        borderRadius: 8,
        paddingHorizontal: 10,
        marginTop: 10
    },
    error: {
        color: 'red',
        marginTop: 4
    },
    buttonBlue: {
        width: 150,
        height: 50,
        backgroundColor: '#448fda',
        borderRadius: 25,
        alignItems: 'center',
        justifyContent: 'center'
    },
    buttonGray: {
        width: 150,
        height: 50,
        backgroundColor: '#808080',
        borderRadius: 25,
        alignItems: 'center',
        justifyContent: 'center'
    },
    buttonText: {
        color: '#fff',
        fontSize: 20,
        fontWeight: '600'
    }
});