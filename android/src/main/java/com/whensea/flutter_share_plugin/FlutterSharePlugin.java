package com.whensea.flutter_share_plugin;

import android.app.Activity;
import android.content.Intent;
import android.net.Uri;

import androidx.annotation.NonNull;

import com.facebook.CallbackManager;
import com.facebook.FacebookCallback;
import com.facebook.FacebookException;
import com.facebook.FacebookSdk;
import com.facebook.share.Sharer;
import com.facebook.share.model.ShareLinkContent;
import com.facebook.share.widget.ShareDialog;
import com.twitter.sdk.android.core.internal.network.UrlUtils;
import com.twitter.sdk.android.tweetcomposer.TweetComposer;

import java.net.MalformedURLException;
import java.net.URL;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * FlutterSharePlugin
 */
public class FlutterSharePlugin implements MethodCallHandler {
    private static CallbackManager mCallbackManager;
    private final Activity mActivity;

    public FlutterSharePlugin(Registrar registrar) {
        mActivity = registrar.activity();
    }

    // This static function is optional and equivalent to onAttachedToEngine. It supports the old
    // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
    // plugin registration via this function while apps migrate to use the new Android APIs
    // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
    //
    // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
    // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
    // depending on the user's project. onAttachedToEngine or registerWith must both be defined
    // in the same class.
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_share_plugin");
        channel.setMethodCallHandler(new FlutterSharePlugin(registrar));
        mCallbackManager = CallbackManager.Factory.create();
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        String url, msg;

        switch (call.method) {
            case "shareFacebook":
                url = call.argument("url");
                msg = call.argument("msg");
                shareToFacebook(url, msg, result);
                break;
            case "shareTwitter":
                url = call.argument("url");
                msg = call.argument("msg");
                shareToTwitter(url, msg, result);
                break;
            case "shareLine":
                url = call.argument("url");
                msg = call.argument("msg");
                shareToLine(url, msg, result);
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    private void shareToLine(String url, String msg, Result result) {
        try {
            String lineScheme = String.format("line://msg/text/%s", UrlUtils.urlEncode(url)).trim();

            Intent intent = new Intent(Intent.ACTION_VIEW, Uri.parse(lineScheme));
            mActivity.startActivity(intent);
        } catch (Exception ex) {
            final String lineUrl =
                    String.format("https://social-plugins.line.me/lineit/share?url=%s", UrlUtils.urlEncode(url));
            Intent intent = new Intent(Intent.ACTION_VIEW, Uri.parse(lineUrl));
            mActivity.startActivity(intent);
        }

//        try {
//            Intent intent = new Intent(Intent.ACTION_SEND);
//            intent.setClassName("jp.naver.line.android", "jp.naver.line.android.activity.selectchat.SelectChatActivityLaunchActivity");
//            intent.setType("text/plain");
//            intent.putExtra(Intent.EXTRA_TEXT,  msg + " " + url);
//            mActivity.startActivity(intent);
////            ComponentName cn = new ComponentName("jp.naver.line.android", "jp.naver.line.android.activity.selectchat.SelectChatActivity");
////            Intent shareIntent = new Intent();
////            shareIntent.setAction(Intent.ACTION_SEND);
////            shareIntent.setType("text/plain"); // 纯文本
////            shareIntent.putExtra(Intent.EXTRA_TEXT, msg + " " + url);
////            shareIntent.setComponent(cn);//跳到指定APP的Activity
////            mActivity.startActivity(Intent.createChooser(shareIntent, ""));
//        } catch (Exception ex) {
//            ex.printStackTrace();
////            Logger.(TAG, "lineShare:" + ex);
//        }
    }

    /**
     * share to twitter
     *
     * @param url    String
     * @param msg    String
     * @param result Result
     */
    private void shareToTwitter(String url, String msg, Result result) {
        try {
            TweetComposer.Builder builder = new TweetComposer.Builder(mActivity);
            if (url != null && url.length() > 0) {
                builder.url(new URL(url));
            }

            builder.show();
            result.success("success");
        } catch (MalformedURLException e) {
            e.printStackTrace();
        }
    }

    /**
     * share to Facebook
     *
     * @param url    String
     * @param msg    String
     * @param result Result
     */
    private void shareToFacebook(String url, String msg, Result result) {

        FacebookSdk.sdkInitialize(mActivity.getApplicationContext());

        ShareDialog shareDialog = new ShareDialog(mActivity);

        // this part is optional
        shareDialog.registerCallback(mCallbackManager, new FacebookCallback<Sharer.Result>() {
            @Override
            public void onSuccess(Sharer.Result result) {
                System.out.println("--------------------success");
            }

            @Override
            public void onCancel() {
                System.out.println("-----------------onCancel");
            }

            @Override
            public void onError(FacebookException error) {
                System.out.println("---------------onError");
            }
        });

        ShareLinkContent content = new ShareLinkContent.Builder()
                .setContentUrl(Uri.parse(url))
//                .setQuote(msg)
                .build();
        if (ShareDialog.canShow(ShareLinkContent.class)) {
            shareDialog.show(content);
            result.success("success");
        }

    }
}
