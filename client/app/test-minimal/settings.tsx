import { useState } from "react";
import { View, Text, TouchableOpacity, Modal, ScrollView, Alert } from "react-native";
import { router } from "expo-router";

const PRIVACY_POLICY = `
隱私政策
我們僅收集執行本系統所需之資料。所有資料均用於環境管理目的，不會另作他用。
如需刪除帳號或資料，請點選下方按鈕。
聯絡方式：your-support@email.com
`;

export default function SettingsScreen() {
    const [modalVisible, setModalVisible] = useState(false);

    const handleDeleteAccount = () => {
        Alert.alert("帳號已刪除", "您的帳號與所有資料已刪除。");
        router.replace("/");
    };

    return (
        <View className="flex-1 px-6 pt-12 bg-white">
            <Text className="text-2xl font-bold mb-8 text-center">設定</Text>
            <TouchableOpacity className="bg-gray-800 rounded-xl py-3 mb-4" onPress={() => setModalVisible(true)}>
                <Text className="text-white text-center font-bold text-base">查看隱私政策</Text>
            </TouchableOpacity>
            <TouchableOpacity className="bg-red-600 rounded-xl py-3 mb-4" onPress={handleDeleteAccount}>
                <Text className="text-white text-center font-bold text-base">刪除帳號</Text>
            </TouchableOpacity>
            <Modal visible={modalVisible} animationType="slide">
                <ScrollView className="flex-1 px-6 pt-12 bg-white">
                    <Text>{PRIVACY_POLICY}</Text>
                    <TouchableOpacity className="mt-8 bg-gray-700 rounded-xl py-3" onPress={() => setModalVisible(false)}>
                        <Text className="text-white text-center font-bold text-base">關閉</Text>
                    </TouchableOpacity>
                </ScrollView>
            </Modal>
        </View>
    );
}
