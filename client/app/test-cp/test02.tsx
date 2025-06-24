// app/screens/RegisterPage.tsx
import React, { useState } from 'react';
import { View, Text, TextInput, ScrollView, TouchableOpacity } from 'react-native';
import { Picker } from '@react-native-picker/picker';

export default function RegisterPage() {
    // form fields
    const [account, setAccount] = useState('');
    const [password, setPassword] = useState('');
    const [shopName, setShopName] = useState('');
    const [ownerName, setOwnerName] = useState('');
    const [phone, setPhone] = useState('');
    const [industry, setIndustry] = useState('餐飲業');
    const [email, setEmail] = useState('');
    const [zipCode, setZipCode] = useState('');
    const [area, setArea] = useState('');
    const [address, setAddress] = useState('');

    const industries = ['餐飲業', '零售業', '其他'];

    // no API call – just log the values for now
    const handleSubmit = () => {
        console.log({
            account,
            password,
            shopName,
            ownerName,
            phone,
            industry,
            email,
            zipCode,
            area,
            address,
        });
    };

    return (
        <ScrollView className="flex-1 bg-white">
            <View className="h-24 bg-blue-500 justify-center items-center">
                <Text className="text-white text-lg font-semibold">註冊</Text>
            </View>

            <View className="px-5 py-8 space-y-5">
                <View>
                    <Text className="mb-1 text-sm">帳號</Text>
                    <TextInput
                        value={account}
                        onChangeText={setAccount}
                        className="border rounded px-3 py-2"
                    />
                </View>

                <View>
                    <Text className="mb-1 text-sm">密碼</Text>
                    <TextInput
                        secureTextEntry
                        value={password}
                        onChangeText={setPassword}
                        className="border rounded px-3 py-2"
                    />
                </View>

                <View>
                    <Text className="mb-1 text-sm">店家名稱</Text>
                    <TextInput
                        value={shopName}
                        onChangeText={setShopName}
                        className="border rounded px-3 py-2"
                    />
                </View>

                <View>
                    <Text className="mb-1 text-sm">負責人</Text>
                    <TextInput
                        value={ownerName}
                        onChangeText={setOwnerName}
                        className="border rounded px-3 py-2"
                    />
                </View>

                <View>
                    <Text className="mb-1 text-sm">連絡電話</Text>
                    <TextInput
                        keyboardType="phone-pad"
                        value={phone}
                        onChangeText={setPhone}
                        className="border rounded px-3 py-2"
                    />
                </View>

                <View>
                    <Text className="mb-1 text-sm">行業別</Text>
                    <View className="border rounded">
                        <Picker selectedValue={industry} onValueChange={(v) => setIndustry(String(v))}>
                            {industries.map((item) => (
                                <Picker.Item label={item} value={item} key={item} />
                            ))}
                        </Picker>
                    </View>
                </View>

                <View>
                    <Text className="mb-1 text-sm">EMAIL</Text>
                    <TextInput
                        keyboardType="email-address"
                        value={email}
                        onChangeText={setEmail}
                        className="border rounded px-3 py-2"
                    />
                </View>

                <View className="flex-row space-x-3">
                    <View className="flex-1">
                        <Text className="mb-1 text-sm">郵遞區號</Text>
                        <TextInput
                            keyboardType="numeric"
                            value={zipCode}
                            onChangeText={setZipCode}
                            className="border rounded px-3 py-2"
                        />
                    </View>

                    <View className="flex-1">
                        <Text className="mb-1 text-sm">地區</Text>
                        <TextInput
                            value={area}
                            onChangeText={setArea}
                            className="border rounded px-3 py-2"
                        />
                    </View>
                </View>

                <View>
                    <Text className="mb-1 text-sm">地址</Text>
                    <TextInput
                        value={address}
                        onChangeText={setAddress}
                        className="border rounded px-3 py-2"
                    />
                </View>

                <TouchableOpacity
                    onPress={handleSubmit}
                    className="mt-8 h-12 rounded bg-blue-500 justify-center items-center"
                >
                    <Text className="text-white font-medium">送出</Text>
                </TouchableOpacity>
            </View>
        </ScrollView>
    );
}
