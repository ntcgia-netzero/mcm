import React, { useState } from 'react';
import {
    View,
    Text,
    TextInput,
    Pressable,
    ActivityIndicator,
    ScrollView,
    Platform,
    Alert,
} from 'react-native';
import { useForm, Controller } from 'react-hook-form';
import { z } from 'zod';
import { zodResolver } from '@hookform/resolvers/zod';
import { router } from 'expo-router';
import { supabase } from '../lib/supabase'; // 請換成你的 Supabase 初始化
import { Feather } from '@expo/vector-icons';
import Checkbox from 'expo-checkbox';
import { Palette } from '@/theme';
import { FormInput, ScreenContainerForm } from '@/components';
const loginSchema = z.object({
    email: z.string().email('請輸入正確的 Email'),
    password: z.string().min(6, '密碼長度至少 6 位').max(16, '密碼長度最多 16 位'),
    remember: z.boolean().optional(),
});

type LoginForm = z.infer<typeof loginSchema>;


export default function LoginScreen() {

    const {
        control,
        handleSubmit,
        formState: { errors, isSubmitting },
    } = useForm<LoginForm>({
        resolver: zodResolver(loginSchema),
        defaultValues: {
            email: '',
            password: '',
            remember: false,
        },
    });

    const onSubmit = async (data: LoginForm) => {
        const { error } = await supabase.auth.signInWithPassword({
            email: data.email,
            password: data.password,
        });

        if (error) {
            console.log('登入失敗:', error.code);
            Alert.alert('登入失敗', error.message);
        } else {
            // TODO
            // 這裡你可以把 remember 做 localStorage 處理
            console.log('保持登入:', data.remember);
            router.replace('/home');
        }
    };

    return (
        <ScreenContainerForm>
            <View className="h-[300px] w-full bg-primary justify-between items-start py-12 px-6">
                <Text className="text-white text-6xl font-extrabold">Micro</Text>
                <Text className="text-white text-6xl font-extrabold">Carbon</Text>
                <Text className="text-white text-6xl font-extrabold">Management</Text>
            </View>

            <View className="w-full px-10 items-center mt-8">
                {/* 電子信箱 */}
                <FormInput
                    control={control}
                    name="email"
                    label="電子信箱"
                    placeholder="輸入電子信箱"
                    keyboardType="email-address"
                    error={errors.email}
                />
                {/* 密碼 */}
                <FormInput
                    control={control}
                    name="password"
                    label="密碼"
                    placeholder="輸入密碼"
                    isPassword
                    error={errors.password}
                    className="mt-4"
                />
                {/* Remember + Forgot */}
                <View className="flex-row justify-between items-center w-full">
                    <Controller
                        control={control}
                        name="remember"
                        render={({ field: { value, onChange } }) => (
                            <Pressable
                                className="flex-row items-center p-6 pl-2 gap-2"
                                onPress={() => onChange(!value)}
                            >
                                <Checkbox
                                    value={value}
                                    color={value ? Palette.primary : undefined}
                                />
                                <Text className="text-sm text-gray-700">保持登入</Text>
                            </Pressable>
                        )}
                    />
                    {/* // TODO Forgot */}
                    {/* <Pressable onPress={() => router.push('/forgot')}>
                                <Text className="text-sm text-primary">忘記密碼？</Text>
                            </Pressable> */}
                </View>

                {/* 登入按鈕 */}
                <Pressable
                    className={`w-44 h-12 rounded-full items-center justify-center mt-4 ${isSubmitting ? 'bg-gray-400' : 'bg-primary'
                        }`}
                    onPress={handleSubmit(onSubmit)}
                    disabled={isSubmitting}
                >
                    {isSubmitting ? (
                        <ActivityIndicator color="#fff" />
                    ) : (
                        <Text className="text-white text-xl font-semibold">登入</Text>
                    )}
                </Pressable>

                {/* 註冊按鈕 */}
                <Pressable
                    className="w-44 h-12 rounded-full bg-gray-500 items-center justify-center mt-5"
                    onPress={() => router.push('/signup')}
                >
                    <Text className="text-white text-xl font-semibold">註冊帳號</Text>
                </Pressable>
            </View>
        </ScreenContainerForm>
    );
}
